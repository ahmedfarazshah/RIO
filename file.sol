// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HomeRentalContract {
    // address private owner;
    // constructor(){
    //     owner=msg.sender;
    // }
    address public landOwner;
    address public Buyer;
    enum DealStatus { Open, Accepted, Completed, Canceled }
    uint public rent;
    modifier onlyBuyer {
    require(msg.sender == Buyer, "Invalid sender");
    _;
}
     modifier onlySeller {
    require(msg.sender == landOwner, "Only the seller can perform this action");
    _;
}

    struct HomeListing {
        address owner;
        string description;
        uint256 price;
        uint256 deposit;
        uint256 availableFrom;
        uint256 availableTo;
        DealStatus status;
    }

    struct RentalDeal {
        address renter;
        uint256 startTime;
        uint256 endTime;
    }

    HomeListing[] public listings;
    RentalDeal[] public rentalDeals;  //deals in an array

    event NewListingAdded(uint256 listingId, address owner);
    event DealCreated(uint256 listingId, address renter, uint256 startTime, uint256 endTime, uint256 dealId);

    modifier onlyOwner(uint256 listingId) {
        require(listings[listingId].owner == msg.sender, "Only the owner can perform this action");
        _;
    }

    function addListing(
        string memory _description,
        address _owner,
        uint256 _price,
        uint256 _deposit,
        uint256 _availableFrom,
        uint256 _availableTo
    ) external {
        landOwner= _owner;
        rent=_price;
        require(_availableFrom < _availableTo, "Invalid date range");
        uint256 listingId = listings.length;
        listings.push(HomeListing(msg.sender, _description, _price, _deposit, _availableFrom, _availableTo, DealStatus.Open));
        emit NewListingAdded(listingId, msg.sender);
    }

    function createRentalDeal(uint256 listingId, uint256 startTime, uint256 endTime) external payable {
        require(listingId < listings.length, "Invalid listing ID");
        HomeListing storage listing = listings[listingId];
        require(listing.status == DealStatus.Open, "This listing is not available for rent");
        require(msg.value >= listing.price + listing.deposit, "Insufficient funds sent");

        uint256 dealId = rentalDeals.length;  
        rentalDeals.push(RentalDeal(msg.sender, startTime, endTime));  

        listing.status = DealStatus.Accepted;
        emit DealCreated(listingId, msg.sender, startTime, endTime, dealId);
    }
     function deposit()public payable onlyBuyer{
      require(msg.value>1000,"low amount entered");
     
     }
    function getbal()public view returns(uint){
        return address(this).balance;
    }

    function Transaction()public payable onlySeller{
        payable(landOwner).transfer(rent);

    }
}