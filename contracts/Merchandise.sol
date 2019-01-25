pragma solidity ^0.5.0;
contract Merchandise {
    address owner;
    
    //to allow turning the marketplace operations off in case of emergency
    //(an alternative of selfdestruct) avoids consequences such as permanent perishing of contract
    bool online;
    
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
    
    constructor() public {
        owner = msg.sender;
        online = true;
        // addItem("First Item", "Added by Contract deployment", 1 ether);
    }


    function kill() public {
        require(msg.sender == owner, "Only contract owner can kill contract");
        selfdestruct(msg.sender);
    }
    
    function setOnline(bool status) public {
        require(msg.sender == owner, "Only contract owner can set online status");
        online = status;
    }
    
    event AddListing(
        address seller,
        string name,
        uint price
    );

    function addItem(string memory name, string memory description, uint price) public returns(uint) {
        
        //validate the store is online (and not discontinued)
        require(online == true, "Adding items not allowed when store is offline");
        
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
    
    //get the item (to display on UI) by its itemId (sku)
    function getItem(uint itemId) public view returns(
        uint, string memory, string memory, uint, bool, bool, bool
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

    //allow buyer to purchase an item    
    function buyItem(uint itemId) public payable returns(bool) {
        //validate the store is online (and not discontinued)
        require(online == true, "Store must be online to buy items");        
        
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

    //allow seller to mark the item as shipped
    function shipItem(uint itemId) public {
        //validate the item has been sold
        require(items[itemId].sold == true, "Cannot ship unsold items");

        //mark the item as shipped (by seller)
        items[itemId].shipped = true;
    }

    //allow buyer to mark the item as received    
    function receiveItem(uint itemId) public {
        //validate the item has been shipped (by seller)
        require(items[itemId].shipped == true, "Cannot receive unshipped items");
        
        //validate the marker of the item as received is the buyer itself
        require(msg.sender == items[itemId].buyer, "Only buyer can mark item as received");

        //mark the item as received (by buyer)
        items[itemId].received = true;
    }
    
    //allow seller to withdraw amount of the item he shipped
    function claimFunds(uint itemId) public {
        //validate the store is online (and not discontinued)
        require(online == true, "Store must be online to claim funds");        
        
        //validate the fund claimer of the item is the seller itself
        require(msg.sender == items[itemId].seller, "Only seller can claim funds");
        
        //validate the item has been received (by buyer)        
        require(items[itemId].received == true, "Cannot claim funds until item received");
        
        //transfer the amount from contract to the seller
        msg.sender.transfer(items[itemId].itemPrice);
    }
    
    //the balance of the Merchandise contract
    function depositsBalance() public view returns (uint) {
        return address(this).balance;
    }
}