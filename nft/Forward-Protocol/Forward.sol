// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Ownable} from "openzeppelin/access/Ownable.sol";
import {ReentrancyGuard} from "openzeppelin/security/ReentrancyGuard.sol";
import {IERC20} from "openzeppelin/token/ERC20/IERC20.sol";
import {IERC721} from "openzeppelin/token/ERC721/IERC721.sol";

import {IBlacklist} from "./interfaces/IBlacklist.sol";
import {IMigrateTo} from "./interfaces/IMigrateTo.sol";
import {IPriceOracle} from "./interfaces/IPriceOracle.sol";

import {IRoyaltyEngine} from "./interfaces/external/IRoyaltyEngine.sol";
import {IConduitController, ISeaport} from "./interfaces/external/ISeaport.sol";

contract Forward is Ownable, ReentrancyGuard {
    // Enums

    enum ItemKind {
        ERC721,
        ERC721_WITH_CRITERIA
    }

    // Structs

    struct Order {
        ItemKind itemKind;
        address maker;
        IERC721 token;
        uint256 identifierOrCriteria;
        uint256 unitPrice;
        // The order's amount is a `uint128` instead of a `uint256` so
        // that the order status can fit within a single storage slot
        uint128 amount;
        uint256 salt;
        uint256 expiration;
    }

    struct OrderStatus {
        bool cancelled;
        uint128 filledAmount;
    }

    struct FillDetails {
        Order order;
        bytes signature;
    }

    struct Item {
        IERC721 token;
        uint256 identifier;
    }

    // Packed representation of a Seaport listing, with the following limitations:
    // - ETH-denominated
    // - fixed-price

    struct Payment {
        uint256 amount;
        address recipient;
    }

    struct SeaportListingDetails {
        address token;
        uint256 identifier;
        uint256 startTime;
        uint256 endTime;
        uint256 salt;
        Payment[] payments;
    }

    // Errors

    error InvalidSeaportConduit();

    error OrderIsCancelled();
    error OrderIsExpired();
    error OrderIsInvalid();

    error InsufficientAmountAvailable();
    error InvalidCriteriaProof();
    error InvalidFillAmount();
    error InvalidSignature();

    error Blacklisted();
    error PaymentFailed();
    error Unauthorized();
    error ZeroMigrateTo();

    error SeaportListingIsInvalid();
    error SeaportListingIsNotFillable();
    error SeaportListingIsUnderpriced();
    error SeaportListingRoyaltiesAreIncorrect();

    // Events

    event BlacklistUpdated(address blacklist);
    event PriceOracleUpdated(address newPriceOracle);
    event RoyaltyEngineUpdated(address newRoyaltyEngine);

    event MigrateToUpdated(address newMigrateTo);
    event MinPriceBpsUpdated(uint256 newMinPriceBps);
    event OraclePriceMaxAgeUpdated(
        uint256 newWithdrawMaxAge,
        uint256 newListMaxAge
    );
    event SeaportConduitUpdated(bytes32 newSeaportConduitKey);

    event CounterIncremented(address maker, uint256 newCounter);

    event OrderCancelled(bytes32 orderHash);
    event OrderFilled(
        bytes32 orderHash,
        address maker,
        address taker,
        address token,
        uint256 identifier,
        uint256 unitPrice
    );

    // Public constants

    IERC20 public constant WETH =
        IERC20(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6);

    ISeaport public constant SEAPORT =
        ISeaport(0x00000000006c3852cbEf3e08E8dF289169EdE581);

    IConduitController public constant CONDUIT_CONTROLLER =
        IConduitController(0x00000000F9490004C11Cef243f5400493c00Ad63);

    bytes32 public constant SEAPORT_DOMAIN_SEPARATOR =
        0x712fdde1f147adcbb0fabb1aeb9c2d317530a46d266db095bc40c606fe94f0c2;

    bytes32 public immutable DOMAIN_SEPARATOR;
    bytes32 public immutable ORDER_TYPEHASH;

    // Public fields

    IBlacklist public blacklist;
    IPriceOracle public priceOracle;
    IRoyaltyEngine public royaltyEngine;

    // Allow royalty-free migrations to new Forward versions (if any)
    IMigrateTo public migrateTo;

    // To avoid the possbility of evading royalties (by withdrawing via
    // private listing to a different own wallet for a zero or very low
    // price) we enforce the price of every outgoing Seaport listing to
    // be within a percentage from the actual token's price (determined
    // via a pricing oracle)
    uint256 public minPriceBps;

    // Depending on the action taken (withdrawing a token or listing externally
    // via Seaport) there are different requirements regarding the staleness of
    // the oracle's price
    uint256 public oraclePriceWithdrawMaxAge;
    uint256 public oraclePriceListMaxAge;

    // Conduit used for Seaport listings from the protocol
    bytes32 public seaportConduitKey;
    address public seaportConduit;

    // Mapping from order hash to order status (eg. cancelled and/or amount filled)
    mapping(bytes32 => OrderStatus) public orderStatuses;
    // Mapping from wallet to current counter
    mapping(address => uint256) public counters;

    // Mapping from item id (eg. `keccak256(abi.encode(token, identifier))) to owner
    mapping(bytes32 => address) public itemOwners;

    // Constructor

    constructor(
        address _blacklist,
        address _priceOracle,
        address _royaltyEngine
    ) {
        blacklist = IBlacklist(_blacklist);
        priceOracle = IPriceOracle(_priceOracle);
        royaltyEngine = IRoyaltyEngine(_royaltyEngine);

        minPriceBps = 8000;

        oraclePriceWithdrawMaxAge = 30 minutes;
        oraclePriceListMaxAge = 1 days;

        // Use OpenSea's default conduit (so that Seaport listings are available on OpenSea)
        seaportConduitKey = 0x0000007b02230091a7ed01230072f7006a004d60a8d4e71d599b8104250f0000;
        seaportConduit = 0x1E0049783F008A0085193E00003D00cd54003c71;

        uint256 chainId;
        assembly {
            chainId := chainid()
        }

        // TODO: Pre-compute and store as a constant
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain("
                    "string name,"
                    "string version,"
                    "uint256 chainId,"
                    "address verifyingContract"
                    ")"
                ),
                keccak256("Forward"),
                keccak256("1.0"),
                chainId,
                address(this)
            )
        );

        // TODO: Pre-compute and store as a constant
        ORDER_TYPEHASH = keccak256(
            abi.encodePacked(
                "Order(",
                "uint8 itemKind,",
                "address maker,",
                "address token,",
                "uint256 identifierOrCriteria,",
                "uint256 unitPrice,",
                "uint128 amount,",
                "uint256 salt,",
                "uint256 expiration,",
                "uint256 counter",
                ")"
            )
        );
    }

    // Restricted methods

    function updateBlacklist(address newBlacklist) external onlyOwner {
        blacklist = IBlacklist(newBlacklist);
        emit BlacklistUpdated(newBlacklist);
    }

    function updatePriceOracle(address newPriceOracle) external onlyOwner {
        priceOracle = IPriceOracle(newPriceOracle);
        emit PriceOracleUpdated(newPriceOracle);
    }

    function updateRoyaltyEngine(address newRoyaltyEngine) external onlyOwner {
        royaltyEngine = IRoyaltyEngine(newRoyaltyEngine);
        emit RoyaltyEngineUpdated(newRoyaltyEngine);
    }

    function updateMigrateTo(address newMigrateTo) external onlyOwner {
        migrateTo = IMigrateTo(newMigrateTo);
        emit MigrateToUpdated(newMigrateTo);
    }

    function updateMinPriceBps(uint256 newMinPriceBps) external onlyOwner {
        minPriceBps = newMinPriceBps;
        emit MinPriceBpsUpdated(newMinPriceBps);
    }

    function updateOraclePriceMaxAge(
        uint256 newWithdrawMaxAge,
        uint256 newListMaxAge
    ) external onlyOwner {
        oraclePriceWithdrawMaxAge = newWithdrawMaxAge;
        oraclePriceListMaxAge = newListMaxAge;
        emit OraclePriceMaxAgeUpdated(newWithdrawMaxAge, newListMaxAge);
    }

    function updateSeaportConduit(bytes32 newSeaportConduitKey)
        external
        onlyOwner
    {
        (address newSeaportConduit, bool exists) = CONDUIT_CONTROLLER
            .getConduit(newSeaportConduitKey);
        if (!exists) {
            revert InvalidSeaportConduit();
        }

        seaportConduitKey = newSeaportConduitKey;
        seaportConduit = newSeaportConduit;
        emit SeaportConduitUpdated(newSeaportConduitKey);
    }

    // Public methods

    function fillBid(FillDetails calldata details) external nonReentrant {
        // Ensure the order is non-criteria-based
        if (uint8(details.order.itemKind) != 0) {
            revert OrderIsInvalid();
        }

        _fillBid(details, details.order.identifierOrCriteria);
    }

    function fillBidWithCriteria(
        FillDetails calldata details,
        uint256 identifier,
        bytes32[] calldata criteriaProof
    ) external nonReentrant {
        // Ensure the order is criteria-based
        if (uint8(details.order.itemKind) != 1) {
            revert OrderIsInvalid();
        }

        // Ensure the provided identifier matches the order's criteria
        if (details.order.identifierOrCriteria != 0) {
            // The zero criteria will match any identifier
            _verifyCriteriaProof(
                identifier,
                details.order.identifierOrCriteria,
                criteriaProof
            );
        }

        _fillBid(details, identifier);
    }

    function cancel(Order[] calldata orders) external {
        uint256 length = orders.length;
        for (uint256 i = 0; i < length; ) {
            Order memory order = orders[i];

            // Only the order's maker can cancel
            if (order.maker != msg.sender) {
                revert Unauthorized();
            }

            // Mark the order as cancelled
            bytes32 orderHash = getOrderHash(order);
            orderStatuses[orderHash].cancelled = true;

            emit OrderCancelled(orderHash);

            unchecked {
                ++i;
            }
        }
    }

    function incrementCounter() external {
        // Similar to Seaport's implementation, incrementing the counter
        // will cancel any orders which were signed with a counter value
        // which is lower than the updated value
        uint256 newCounter;
        unchecked {
            newCounter = ++counters[msg.sender];
        }

        emit CounterIncremented(msg.sender, newCounter);
    }

    function deposit(Item[] calldata items) external nonReentrant {
        uint256 length = items.length;
        for (uint256 i = 0; i < length; ) {
            Item calldata item = items[i];

            IERC721 token = item.token;
            uint256 identifier = item.identifier;

            // Transfer the token in
            token.safeTransferFrom(msg.sender, address(this), identifier);

            // Update internal ownership
            bytes32 itemId = keccak256(abi.encode(token, identifier));
            itemOwners[itemId] = msg.sender;

            unchecked {
                ++i;
            }
        }
    }

    function withdraw(
        Item[] memory items,
        bytes[] memory data,
        address recipient
    ) public payable nonReentrant {
        uint256 itemsLength = items.length;
        for (uint256 i = 0; i < itemsLength; ) {
            Item memory item = items[i];

            IERC721 token = item.token;
            uint256 identifier = item.identifier;

            // Ensure the sender is the item's owner
            bytes32 itemId = keccak256(abi.encode(token, identifier));
            address owner = itemOwners[itemId];
            if (msg.sender != owner) {
                revert Unauthorized();
            }

            // Fetch the token's price
            uint256 price = priceOracle.getPrice(
                address(token),
                identifier,
                oraclePriceWithdrawMaxAge,
                // Oracle off-chain data
                data[i]
            );

            // Fetch the item's royalties (relative to the token's price)
            (
                address[] memory royaltyRecipients,
                uint256[] memory royaltyAmounts
            ) = royaltyEngine.getRoyaltyView(address(token), identifier, price);

            // Pay the royalties
            uint256 recipientsLength = royaltyRecipients.length;
            for (uint256 j = 0; j < recipientsLength; ) {
                _sendPayment(royaltyRecipients[j], royaltyAmounts[j]);

                unchecked {
                    ++j;
                }
            }

            // Transfer the token
            token.safeTransferFrom(address(this), recipient, identifier);

            // Clear internal ownership
            itemOwners[itemId] = address(0);

            unchecked {
                ++i;
            }
        }
    }

    function migrate(Item[] calldata items) external {
        IMigrateTo localMigrateTo = migrateTo;
        if (address(localMigrateTo) == address(0)) {
            revert ZeroMigrateTo();
        }

        uint256 length = items.length;
        for (uint256 i = 0; i < length; ) {
            Item calldata item = items[i];

            IERC721 token = item.token;
            uint256 identifier = item.identifier;

            // Ensure the sender is the item's owner
            bytes32 itemId = keccak256(abi.encode(token, identifier));
            address owner = itemOwners[itemId];
            if (msg.sender != owner) {
                revert Unauthorized();
            }

            // Transfer the token to the migration contract
            token.safeTransferFrom(
                address(this),
                address(localMigrateTo),
                identifier
            );

            // Process the migrated item
            localMigrateTo.processMigratedItem(token, identifier, owner);

            // Clear internal ownership
            itemOwners[itemId] = address(0);

            unchecked {
                ++i;
            }
        }
    }

    function getOrderHash(Order memory order)
        public
        view
        returns (bytes32 orderHash)
    {
        address maker = order.maker;

        // TODO: Optimize by using assembly
        orderHash = keccak256(
            abi.encode(
                ORDER_TYPEHASH,
                order.itemKind,
                maker,
                order.token,
                order.identifierOrCriteria,
                order.unitPrice,
                order.amount,
                order.salt,
                order.expiration,
                counters[maker]
            )
        );
    }

    // ERC1271

    function isValidSignature(bytes32 digest, bytes memory signature)
        external
        view
        returns (bytes4)
    {
        // Ensure any Seaport order originating from this vault is a listing
        // in the native token which is paying out the correct royalties (as
        // specified via the royalty registry)

        (
            SeaportListingDetails memory listingDetails,
            bytes memory orderSignature,
            bytes memory oracleOffChainData
        ) = abi.decode(signature, (SeaportListingDetails, bytes, bytes));

        // The listing should have a single offer item
        ISeaport.OfferItem[] memory offer = new ISeaport.OfferItem[](1);
        offer[0] = ISeaport.OfferItem({
            itemType: ISeaport.ItemType.ERC721,
            token: listingDetails.token,
            identifierOrCriteria: listingDetails.identifier,
            startAmount: 1,
            endAmount: 1
        });

        // Keep track of the total payment amount
        uint256 totalPrice;

        Payment[] memory payments = listingDetails.payments;
        uint256 paymentsLength = payments.length;

        // Construct the consideration items
        ISeaport.ConsiderationItem[]
            memory consideration = new ISeaport.ConsiderationItem[](
                paymentsLength
            );
        {
            for (uint256 i = 0; i < paymentsLength; ) {
                Payment memory payment = payments[i];

                uint256 amount = payment.amount;
                totalPrice += amount;

                consideration[i] = ISeaport.ConsiderationItem({
                    itemType: ISeaport.ItemType.NATIVE,
                    token: address(0),
                    identifierOrCriteria: 0,
                    startAmount: amount,
                    endAmount: amount,
                    recipient: payment.recipient
                });

                unchecked {
                    ++i;
                }
            }
        }

        address maker = payments[0].recipient;

        // Ensure the maker owns the listed item
        bytes32 itemId = keccak256(
            abi.encode(listingDetails.token, listingDetails.identifier)
        );
        if (itemOwners[itemId] != maker) {
            revert SeaportListingIsNotFillable();
        }

        // Fetch the token's price
        uint256 price = priceOracle.getPrice(
            listingDetails.token,
            listingDetails.identifier,
            oraclePriceListMaxAge,
            oracleOffChainData
        );

        // Ensure the listing's price is within `minPriceBps` of the token's price
        if (totalPrice < (price * minPriceBps) / 10000) {
            revert SeaportListingIsUnderpriced();
        }

        {
            // Fetch the item's royalties
            (
                address[] memory royaltyRecipients,
                uint256[] memory royaltyAmounts
            ) = royaltyEngine.getRoyaltyView(
                    listingDetails.token,
                    listingDetails.identifier,
                    totalPrice
                );

            // Ensure the royalties are present in the payment items
            // (ordering matters and should match the royalty engine)
            uint256 totalRoyaltyAmount;
            uint256 diff = paymentsLength - royaltyAmounts.length;
            for (uint256 i = diff; i < paymentsLength; ) {
                if (
                    payments[i].recipient != royaltyRecipients[i - diff] ||
                    payments[i].amount != royaltyAmounts[i - diff]
                ) {
                    revert SeaportListingRoyaltiesAreIncorrect();
                }

                totalRoyaltyAmount += royaltyAmounts[i - diff];

                unchecked {
                    ++i;
                }
            }
        }

        bytes32 orderHash;
        {
            ISeaport.OrderComponents memory order;
            order.offerer = address(this);
            // order.zone = address(0);
            order.offer = offer;
            order.consideration = consideration;
            order.orderType = ISeaport.OrderType.PARTIAL_OPEN;
            order.startTime = listingDetails.startTime;
            order.endTime = listingDetails.endTime;
            // order.zoneHash = bytes32(0);
            order.salt = listingDetails.salt;
            order.conduitKey = seaportConduitKey;
            order.counter = SEAPORT.getCounter(address(this));

            orderHash = SEAPORT.getOrderHash(order);
        }

        if (
            digest !=
            keccak256(
                abi.encodePacked(hex"1901", SEAPORT_DOMAIN_SEPARATOR, orderHash)
            )
        ) {
            revert SeaportListingIsInvalid();
        }

        _verifySignature(maker, digest, orderSignature);

        return this.isValidSignature.selector;
    }

    // ERC721

    function onERC721Received(
        address operator,
        address, // from
        uint256, // tokenId
        bytes calldata // data
    ) external view returns (bytes4) {
        if (operator != address(this)) {
            revert Unauthorized();
        }

        if (blacklist.isBlacklisted(msg.sender)) {
            revert Blacklisted();
        }

        return this.onERC721Received.selector;
    }

    // Internal methods

    function _fillBid(FillDetails memory details, uint256 identifier) internal {
        Order memory order = details.order;

        IERC721 token = order.token;
        address maker = order.maker;

        // Ensure the order is not expired
        if (order.expiration <= block.timestamp) {
            revert OrderIsExpired();
        }

        // Ensure the maker's signature is valid
        bytes32 orderHash = getOrderHash(order);
        bytes32 eip712Hash = _getEIP712Hash(orderHash);
        _verifySignature(maker, eip712Hash, details.signature);

        OrderStatus memory orderStatus = orderStatuses[orderHash];
        // Ensure the order is not cancelled
        if (orderStatus.cancelled) {
            revert OrderIsCancelled();
        }
        // Ensure the order is fillable
        if (order.amount - orderStatus.filledAmount == 0) {
            revert InsufficientAmountAvailable();
        }

        // Send the payment to the taker
        WETH.transferFrom(maker, msg.sender, order.unitPrice);

        // Transfer the token in
        token.safeTransferFrom(msg.sender, address(this), identifier);

        // Update internal ownership
        bytes32 itemId = keccak256(abi.encode(token, identifier));
        itemOwners[itemId] = maker;

        // Give approval for listing if needed
        address conduit = seaportConduit;
        bool isApproved = token.isApprovedForAll(address(this), conduit);
        if (!isApproved) {
            token.setApprovalForAll(conduit, true);
        }

        // Update the order's filled amount
        orderStatuses[orderHash].filledAmount += 1;

        emit OrderFilled(
            orderHash,
            maker,
            msg.sender,
            address(token),
            identifier,
            order.unitPrice
        );
    }

    function _getEIP712Hash(bytes32 structHash)
        internal
        view
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked(hex"1901", DOMAIN_SEPARATOR, structHash)
            );
    }

    function _sendPayment(address to, uint256 value) internal {
        (bool success, ) = payable(to).call{value: value}("");
        if (!success) {
            revert PaymentFailed();
        }
    }

    // Taken from:
    // https://github.com/ProjectOpenSea/seaport/blob/dfce06d02413636f324f73352b54a4497d63c310/contracts/lib/CriteriaResolution.sol#L243-L247
    function _verifyCriteriaProof(
        uint256 leaf,
        uint256 root,
        bytes32[] memory criteriaProof
    ) internal pure {
        bool isValid;

        assembly {
            // Store the leaf at the beginning of scratch space
            mstore(0, leaf)

            // Derive the hash of the leaf to use as the initial proof element
            let computedHash := keccak256(0, 0x20)
            // Get memory start location of the first element in proof array
            let data := add(criteriaProof, 0x20)

            for {
                // Left shift by 5 is equivalent to multiplying by 0x20
                let end := add(data, shl(5, mload(criteriaProof)))
            } lt(data, end) {
                // Increment by one word at a time
                data := add(data, 0x20)
            } {
                // Get the proof element
                let loadedData := mload(data)

                // Sort proof elements and place them in scratch space
                let scratch := shl(5, gt(computedHash, loadedData))
                mstore(scratch, computedHash)
                mstore(xor(scratch, 0x20), loadedData)

                // Derive the updated hash
                computedHash := keccak256(0, 0x40)
            }

            isValid := eq(computedHash, root)
        }

        if (!isValid) {
            revert InvalidCriteriaProof();
        }
    }

    // Taken from:
    // https://github.com/ProjectOpenSea/seaport/blob/e4c6e7b294d7b564fe3fe50c1f786cae9c8ec575/contracts/lib/SignatureVerification.sol#L31-L35
    function _verifySignature(
        address signer,
        bytes32 digest,
        bytes memory signature
    ) internal view {
        bool success;

        // TODO: Add support for EIP1271 contract signatures
        assembly {
            // Ensure that first word of scratch space is empty
            mstore(0, 0)

            let v
            let signatureLength := mload(signature)

            // Get the pointer to the value preceding the signature length
            let wordBeforeSignaturePtr := sub(signature, 0x20)

            // Cache the current value behind the signature to restore it later
            let cachedWordBeforeSignature := mload(wordBeforeSignaturePtr)

            // Declare lenDiff + recoveredSigner scope to manage stack pressure
            {
                // Take the difference between the max ECDSA signature length and the actual signature length
                // Overflow desired for any values > 65
                // If the diff is not 0 or 1, it is not a valid ECDSA signature
                let lenDiff := sub(65, signatureLength)

                let recoveredSigner

                // If diff is 0 or 1, it may be an ECDSA signature, so try to recover signer
                if iszero(gt(lenDiff, 1)) {
                    // Read the signature `s` value
                    let originalSignatureS := mload(add(signature, 0x40))

                    // Read the first byte of the word after `s`
                    // If the signature is 65 bytes, this will be the real `v` value
                    // If not, it will need to be modified - doing it this way saves an extra condition
                    v := byte(0, mload(add(signature, 0x60)))

                    // If lenDiff is 1, parse 64-byte signature as ECDSA
                    if lenDiff {
                        // Extract yParity from highest bit of vs and add 27 to get v
                        v := add(shr(0xff, originalSignatureS), 27)

                        // Extract canonical s from vs, all but the highest bit
                        // Temporarily overwrite the original `s` value in the signature
                        mstore(
                            add(signature, 0x40),
                            and(
                                originalSignatureS,
                                0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
                            )
                        )
                    }

                    // Temporarily overwrite the signature length with `v` to conform to the expected input for ecrecover
                    mstore(signature, v)

                    // Temporarily overwrite the word before the length with `digest` to conform to the expected input for ecrecover
                    mstore(wordBeforeSignaturePtr, digest)

                    // Attempt to recover the signer for the given signature
                    // Do not check the call status as ecrecover will return a null address if the signature is invalid
                    pop(
                        staticcall(
                            gas(),
                            1, // Call ecrecover precompile
                            wordBeforeSignaturePtr, // Use data memory location
                            0x80, // Size of digest, v, r, and s
                            0, // Write result to scratch space
                            0x20 // Provide size of returned result
                        )
                    )

                    // Restore cached word before signature
                    mstore(wordBeforeSignaturePtr, cachedWordBeforeSignature)

                    // Restore cached signature length
                    mstore(signature, signatureLength)

                    // Restore cached signature `s` value
                    mstore(add(signature, 0x40), originalSignatureS)

                    // Read the recovered signer from the buffer given as return space for ecrecover
                    recoveredSigner := mload(0)
                }

                // Set success to true if the signature provided was a valid ECDSA signature and the signer is not the null address
                // Use gt instead of direct as success is used outside of assembly
                success := and(eq(signer, recoveredSigner), gt(signer, 0))
            }
        }

        if (!success) {
            revert InvalidSignature();
        }
    }
}