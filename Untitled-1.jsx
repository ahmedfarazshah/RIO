import React, { useState, useEffect } from "react";
import Web3 from "web3";

const contractAddress = "0x5B38Da6a701c568545dC3389Fd06B93B366E3D64";

const HomeRentalContract = () => {
  const [listings, setListings] = useState([]);
  const [rentalDeals, setRentalDeals] = useState([]);

  useEffect(() => {
    const web3 = new Web3();
    const contract = new web3.eth.Contract(
      [
        // Paste the Solidity contract ABI here
      ],
      contractAddress
    );

    async function getListings() {
      const listings = await contract.methods.listings().call();
      setListings(listings);
    }

    async function getRentalDeals() {
      const rentalDeals = await contract.methods.rentalDeals().call();
      setRentalDeals(rentalDeals);
    }

    getListings();
    getRentalDeals();
  }, []);

  const rentListing = async (listingId) => {
    const contract = new Web3().eth.Contract(
      [
        // Paste the Solidity contract ABI here
      ],
      contractAddress
    );

    const listing = await contract.methods.listings(listingId).call();

    const rentalPrice = listing.price + listing.deposit;

    await contract.methods
      .createRentalDeal(listingId, new Date().getTime() + 24 * 60 * 60 * 1000, new Date().getTime() + 48 * 60 * 60 * 1000)
      .send({ from: Web3.eth.defaultAccount, value: rentalPrice });

    // Update the listing status
    listing.status = "Accepted";
    await contract.methods.listings(listingId).update(listing);

    // Update the listings table
    getListings();
  };

  return (
    <div>
      <h1>Home Rental Contract</h1>

      <table>
        <thead>
          <tr>
            <th>Listing ID</th>
            <th>Owner</th>
            <th>Description</th>
            <th>Price</th>
            <th>Deposit</th>
            <th>Available From</th>
            <th>Available To</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {listings.map((listing) => (
            <tr key={listing.listingId}>
              <td>{listing.listingId}</td>
              <td>{listing.owner}</td>
              <td>{listing.description}</td>
              <td>{listing.price}</td>
              <td>{listing.deposit}</td>
              <td>{listing.availableFrom}</td>
              <td>{listing.availableTo}</td>
              <td>{listing.status}</td>
              <td>
                <button onClick={() => rentListing(listing.listingId)}>Rent</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default HomeRentalContract;