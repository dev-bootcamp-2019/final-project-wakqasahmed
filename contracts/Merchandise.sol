pragma solidity ^0.5.0;

import "../libraries/SafeMath.sol";
import "../libraries/StringUtils.sol";

/** @title Goods and services merchandising */
contract Merchandise {
    address owner;

    using SafeMath for uint;
    using StringUtils for string;

    //to allow turning the marketplace operations off in case of emergency - Circuit Breakers (Pause contract functionality)
    //(an alternative of selfdestruct) avoids consequences such as permanent perishing of contract
    bool private online;

    //item entity
    struct Item {
        uint itemId;
        address seller;
        address buyer;
        string itemName;
        string itemDesc;
        uint itemPrice;
        bool sold;
        bool shipped;
        bool received;
    }
    
    Item[] public items;

    modifier isAdmin() {
        require(msg.sender == owner, "Only contract owner can perform this action");
        _;
    }

    modifier notEmpty(string memory _string) {
        require (!StringUtils.equal(_string, ""), "String cannot be empty");
        _;
    }

    modifier isOnline() {
        require(online == true, "Action cannot be performed since the store is offline");
        _;
    }

    constructor() public {
        owner = msg.sender;
        online = true;
    }

    //allow switching the store on/off [Circuit Breakers (Pause contract functionality)]    
    function setOnline(bool status) public isAdmin {
        //require(msg.sender == owner, "Only contract owner can set online status");
        online = status;
    }

    //in case owner decides to permanently erase the contract from the blockchain
    function kill() public isAdmin {
        //require(msg.sender == owner, "Only contract owner can kill contract");
        selfdestruct(msg.sender);
    }

    //For logging of new item creation
    event AddListing(
        address seller,
        string name,
        uint price
    );

    /** @dev Adds an item with its price
      * @param name Name of the item.
      * @param description Description of the item.
      * @param price Price of the item.
      * @return totalItems Total number of items in the items array.
      */
    function addItem(string memory name, string memory description, uint price) public isOnline notEmpty(name) returns(uint totalItems) {
        
        //validate the store is online (and not discontinued)
        //require(online == true, "Adding items not allowed when store is offline");
        
        //validate the price to be greater than zero
        require(price > 0, "Price must be greater than zero");

        //get the current length of items array to validate after the item is added
        uint initialLength = items.length;
        
        //add new item to the items array
        items.push(Item({
            itemId: items.length,
            seller: msg.sender,
            buyer: address(0),
            itemName: name,
            itemDesc: description,
            itemPrice: price,
            sold: false,
            shipped: false,
            received: false
        }));

        emit AddListing(msg.sender, name, price);        
        
        //confirm that exactly one item has been added successfully
        assert(items.length == initialLength + 1);

        return items.length;
    }

    /** @dev Get the item by its itemId (sku)
      * @param itemId Identifier of the item (a sequential number).
      * @return id The identifier of the item.
      * @return name The name of the item.
      * @return description The description of the item.
      * @return price The price of the item.
      * @return isSold Has the item sold to a buyer.
      * @return isShipped Has the item shipped by seller.
      * @return isReceived Has the item received by buyer.
      */   
    function getItem(uint itemId) public view returns(
        uint id, string memory name, string memory description, uint price, bool isSold, bool isShipped, bool isReceived
    ){
        return (
            items[itemId].itemId,
            items[itemId].itemName,
            items[itemId].itemDesc,
            items[itemId].itemPrice,            
            items[itemId].sold,
            items[itemId].shipped,
            items[itemId].received            
        );       
    }

    /** @dev allows buyer to purchase an item by paying price in ether
      * @param itemId Identifier of the item to buy
      * @return result A boolean to indicate whether the operation was successful.
      */     
    function buyItem(uint itemId) public isOnline payable returns(bool result) {
        //validate the store is online (and not discontinued)
        //require(online == true, "Store must be online to buy items");        
        
        //validate the buyer is not the seller itself (and purchasing for the sake of rising its rating/reviews)
        //require(msg.sender == items[itemId].seller, "Cannot purchase items that you yourself are selling");

        //validate the item is available for sale
        require(items[itemId].sold == false, "Cannot purchase items already sold");

        //validate the paid/deposit amount is equal to the item's price
        require(msg.value == items[itemId].itemPrice, "Submitted ether must be equal to the item price");
        
        //set the buyer's address 
        items[itemId].buyer = msg.sender;
        
        //mark the item as sold
        items[itemId].sold = true;

        return true;
    }

    /** @dev allows seller to mark the item as shipped
      * @param itemId Identifier of the item to mark
      * @return result A boolean to indicate whether the operation was successful.
      */     
    function shipItem(uint itemId) public returns(bool result){
        //validate the item has been sold
        require(items[itemId].sold == true, "Cannot ship unsold items");

        //mark the item as shipped (by seller)
        items[itemId].shipped = true;

        return true;
    }

    /** @dev allows buyer to mark the item as received
      * @param itemId Identifier of the item to mark
      */ 
    function receiveItem(uint itemId) public {
        //validate the item has been shipped (by seller)
        require(items[itemId].shipped == true, "Cannot receive unshipped items");
        
        //validate the marker of the item as received is the buyer itself
        require(msg.sender == items[itemId].buyer, "Only buyer can mark item as received");

        //mark the item as received (by buyer)
        items[itemId].received = true;
    }
    
    /** @dev allows seller to withdraw amount of the item he/she shipped
      * @param itemId Identifier of the item to mark
      */     
    function claimFunds(uint itemId) public isOnline {
        //validate the store is online (and not discontinued)
        //require(online == true, "Store must be online to claim funds");        
        
        //validate the fund claimer of the item is the seller itself
        require(msg.sender == items[itemId].seller, "Only seller can claim funds");
        
        //validate the item has been received (by buyer)        
        require(items[itemId].received == true, "Cannot claim funds until item received");
        
        //transfer the amount from contract to the seller
        msg.sender.transfer(items[itemId].itemPrice);
    }
}