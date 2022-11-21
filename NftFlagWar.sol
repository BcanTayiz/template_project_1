pragma solidity ^0.8.0;

import "@openzeppelin/security/ReentrancyGuard.sol";
import "@openzeppelin/access/Ownable.sol";

contract Dots is Ownable,ReentrancyGuard
{

	enum Types{ Nulland,Argentina, Australia, Brazil, Canada, China, France, Germany, India, Indonesia, Italy, Japan, Korea, Mexico, Russia, SaudiArabia, SouthAfrica, Turkey, Ukraine, UnitedKingdom,  UnitedStates}
	
	enum State {
		Available, Paused, Completed
	}
	
	uint constant public x_width = 50;
	uint constant public y_width = 50;
	uint constant public EPSILON = 0.01 ether;	
	uint constant public CLAIM_BASE_PRICE = 0.1 ether;
	
	State public state;

	mapping (uint => mapping(uint => Dot)) public lots;
	mapping (Types=>uint) public dist;
	Types[x_width][y_width] public slate;
	//mapping (address=>uint) public balances;	
	struct Dot
	{
		address owner;
		Types country; 
		uint last_price;
	}

	event Transfer(uint indexed x,
					uint indexed y,
					uint indexed price,Types new_country);

	constructor(uint x_w,uint y_w)
	{
		//x_width = x_w;
		//y_width = y_w;
		state = State.Available;
	}

	function claimLocation(uint x, uint y, Types country) nonReentrant public payable
	{
		require(msg.sender == tx.origin,"Contracts can't bid");
		require(state == State.Available,"Game is paused or ended");
		require(msg.value >= CLAIM_BASE_PRICE, "lower-bound unsatisfied");
		require(msg.value >= lots[x][y].last_price + EPSILON, "delta_bid must be geq to epsilon");
		require(x <= x_width && y <= y_width, "undefined coordinates");
		require(Types.Nulland < country && country <= Types.UnitedStates, "undefined country");
		//fee %.1 for location transactions
		(bool success,) = payable(lots[x][y].owner).call{value:(msg.value*999)/1000}("");
		require(success,"fail during payment");
		if(dist[lots[x][y].country] > 0){
			dist[lots[x][y].country] -= 1;
		}
		dist[country] += 1;
		slate[x][y] = country;

		lots[x][y].last_price = msg.value;
		lots[x][y].owner = msg.sender;
		lots[x][y].country = country;

		emit Transfer(x,y,msg.value, country);
		//game over if one country claimed every point
		if(dist[country] == (x_width * y_width))
		{
			state = State.Completed;
		}
	}

	function setState(State new_state) onlyOwner public{
		state = new_state;
	}

	function claimOwnerCut() onlyOwner public
	{
		/// @TODO: Mechanism design for protocol cuts
		require(state == State.Completed,"Game is not ended yet.");
	
		(bool success,) = payable(owner()).call{value:(address(this).balance*15)/100}("");
		require(success,"claim failed");
	}

	function returnSlate() public view returns (Types[x_width][y_width] memory arr){
		return slate;
	}

/*
	function recoverBalance() public {
		require(balances[msg.sender] > 0, "You have no balance to recover");
		(bool success, ) = payable(msg.sender).call{value:balances[msg.sender]}("");
		require(success,"Payment failed");
	}
*/
}
