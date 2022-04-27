pragma solidity ^0.8.11;

contract Dots
{
	enum Types{Nulland,Switzerland, Greece, Italia, France, USA, Russia, Ukraine, Turkey}
	
	uint constant public x_width = 300;
	uint constant public y_width = 300;
	uint constant public EPSILON = 0.01 ether;	
	uint constant public CLAIM_BASE_PRICE = 1 ether;
	uint game_on;
	uint guard;


	mapping (address=>uint) balances;
	mapping (uint => mapping(uint => Dot)) lots;
	mapping (Types=>uint) dist;
	
	struct Dot
	{
		address owner;
		Types country; 
		uint last_price;
	}

	modifier mutex()
	{
		guard += 1;
		uint count = guard;
		_;
		require(count == guard);
	}

	constructor()
	{
		guard = 1;
		game_on = 1;
	}

	function claimLocation(uint x, uint y, Types country) public payable
	{
		require(x <= x_width && y <= y_width, "undefined coordinates");
		require(Types.Nulland < country && country <= Types.Turkey, "undefined country");
		require(game_on == 1,"game is not on");

		uint price_paid;

		if(lots[x][y].owner == address(0))
		{
			require(msg.value >= CLAIM_BASE_PRICE, "insufficient value");
			balances[msg.sender] += msg.value - CLAIM_BASE_PRICE;
			price_paid = CLAIM_BASE_PRICE;
			dist[country] += 1;
		}
		else
		{
			require(msg.value >= lots[x][y].last_price + EPSILON, "delta_bid must be geq to epsilon");
			price_paid = msg.value;
			//fee %.1 for location transactions
			balances[lots[x][y].owner] += (price_paid*999)/1000;
			dist[lots[x][y].country] -= 1;
			dist[country] += 1;
		}
		lots[x][y].last_price = price_paid;
		lots[x][y].owner = msg.sender;
		lots[x][y].country = country;
		//game over one country claimed every point
		if(dist[country] == (x_width * y_width))
		{
			game_on = 0;
		}
	}

	function claimableBalance() view public returns(uint)
	{
		return balances[msg.sender];
	}
	
	function ownerOf(uint x, uint y) view public returns(address)
	{
		return lots[x][y].owner; 
	}
	
	function lotPrice(uint x,uint y) view public returns(uint)
	{
		return lots[x][y].last_price;
	}

	function lotCount(Types country) view public returns(uint)
	{
		return dist[country];
	}

	function claimBalance() mutex public 
	{
		require(balances[msg.sender] > 0,"no claimable balance for address");
		uint amount = balances[msg.sender];
		(bool success, ) = payable(msg.sender).call{value:amount}("");
		require(success,"failed transfer");
		balances[msg.sender] -= amount;
	}

	receive() external payable
	{
		balances[msg.sender] += msg.value;
	}
}
