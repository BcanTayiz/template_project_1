// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Dots is Ownable
{
	enum Types{Nulland,Switzerland, Greece, Italia, France, USA, Russia, Ukraine, Turkey}
	
	uint constant public x_width = 300;
	uint constant public y_width = 300;
	uint constant public EPSILON = 0.001 ether;	
	uint constant public CLAIM_BASE_PRICE = 1 ether;
	uint game_on;
	uint guard;

    struct Dot
	{
		address owner;
		Types country; 
		uint last_price;
	}


	mapping (address=>uint) balances;
	mapping (uint => mapping(uint => Dot)) lots;
	mapping (Types=>uint) dist;
	
	

	modifier mutex()
	{
		guard += 1;
		uint count = guard;
		_;
		require(count == guard);
	}

     enum State {
          Available,  Completed
          }

     State private currentState;

	constructor()
	{
		guard = 1;
		currentState = State.Available;
	}

   

	function claimLocation(uint x, uint y, Types country) public payable
	{
		require(x <= x_width && y <= y_width, "undefined coordinates");
		require(Types.Nulland < country && country <= Types.Turkey, "undefined country");
		require(currentState == State.Available, "game is not avaliable");

		uint price_paid;
        uint amount;

		if(lots[x][y].owner == address(0))
		{
			require(msg.value >= CLAIM_BASE_PRICE, "insufficient value");
			balances[msg.sender] += msg.value - CLAIM_BASE_PRICE;
			price_paid = CLAIM_BASE_PRICE;
			dist[country] += 1;
		}
		else
		{
			require(msg.value >= lots[x][y].last_price + EPSILON, "You must pay the last price + fee");
			price_paid = msg.value;
			balances[lots[x][y].owner] += (price_paid*999)/1000;
            amount = balances[lots[x][y].owner];
            (bool success, ) = payable(lots[x][y].owner).call{value:amount}("");
            require(success,"failed transfer");
            balances[lots[x][y].owner] -= amount;
			dist[lots[x][y].country] -= 1;
			dist[country] += 1;
		}

		lots[x][y].last_price = price_paid;
		lots[x][y].owner = msg.sender;
		lots[x][y].country = country;
		
		if(dist[country] == (x_width * y_width))
		{
			currentState == State.Completed;
		}
	}



	
	
	function ownerOf(uint x, uint y) view public returns(address)
	{
		return lots[x][y].owner; 
	}
	
	function lotPrice(uint x,uint y) view public returns(uint)
	{
		return lots[x][y].last_price;
	}

    function lotCountry(uint x,uint y) view public returns(Types)
	{
		return lots[x][y].country;
	}

	function lotCount(Types country) view public returns(uint)
	{
		return dist[country];
	}


	receive() external payable
	{
		balances[msg.sender] += msg.value;
	}

   function setState(State newState) external onlyOwner  {
         
                		currentState = newState;
        
								}
}
