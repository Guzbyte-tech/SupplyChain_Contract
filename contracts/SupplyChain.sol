// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    
    // Enum representing different stages of the supply chain
    enum State {
        Created,
        InTransit,
        Delivered
    }
    
    // Structure representing a product in the supply chain
    struct Product {
        string name;
        uint256 productId;
        address owner;
        State state;
    }

    // Mapping to track product ownership by product ID
    mapping(uint256 => Product) public products;

    // Counter to generate product IDs
    uint256 public productCounter = 0;
    event ProductCreated(uint256 indexed productId, address indexed owner, string name);

    event ProductTransferred(uint256 indexed productId, address indexed from, address indexed to, State state);

    event ProductDelivered(uint256 indexed productId, address indexed owner);

    modifier onlyOwner(uint256 productId) {
        require(products[productId].owner == msg.sender, "Only the owner can perform this action");
        _;
    }

    // Modifier to ensure the product is in a specific state
    modifier inState(uint256 productId, State expectedState) {
        require(products[productId].state == expectedState, "Invalid state for this action");
        _;
    }

    function createProduct(string memory name) public {
        productCounter += 1;
        uint256 productId = productCounter;

        products[productId] = Product({
            name: name,
            productId: productId,
            owner: msg.sender,
            state: State.Created
        });

        emit ProductCreated(productId, msg.sender, name);
    }

    // Function to transfer product to another participant
    function transferProduct(uint256 productId, address newOwner) 
        public 
        onlyOwner(productId) 
        inState(productId, State.Created) 
    {
        products[productId].owner = newOwner;
        products[productId].state = State.InTransit;

        emit ProductTransferred(productId, msg.sender, newOwner, State.InTransit);
    }

    // Function to mark product as delivered
    function markProductDelivered(uint256 productId) 
        public 
        onlyOwner(productId) 
        inState(productId, State.InTransit) 
    {
        products[productId].state = State.Delivered;

        emit ProductDelivered(productId, msg.sender);
    }

    // Function to get product details by its ID
    function getProduct(uint256 productId) 
        public 
        view 
        returns (string memory name, uint256 id, address owner, State state) 
    {
        Product memory product = products[productId];
        return (product.name, product.productId, product.owner, product.state);
    }
}
