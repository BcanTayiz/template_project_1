pragma solidity ^0.8.11;

import "forge-std/Test.sol";
import "../Dots.sol";

contract DotsTest is Test
{
	Dots dots;

	function setUp() public
	{
		dots = new Dots();
		uint256 test;
	}

	function testFailClaimFlatTx() public
	{
		// expect revert if no value in the msg
		dots.claimLocation(100,100,Dots.Types.Turkey);
	}
	function testFailClaimCurvedTx() public
	{
		// less than base claim price
		dots.claimLocation{value:dots.CLAIM_BASE_PRICE() / 2}(100,100,Dots.Types.Turkey);
	}
	function testFlatFirstClaim() public
	{
		uint funding = 100 ether;
		vm.startPrank(address(0xAAAA));
		vm.deal(address(0xAAAA),funding);
		dots.claimLocation{value:dots.CLAIM_BASE_PRICE()}(100,100,Dots.Types.Turkey);
		vm.stopPrank();
		require(address(0xAAAA).balance <= funding - dots.CLAIM_BASE_PRICE(),"User paid less than it should");
		require(address(dots).balance >= dots.CLAIM_BASE_PRICE(),"Contract leaks flow"); 
	}

	function testCurvedFirstClaim() public
	{
		uint funding = 100 ether;
		vm.startPrank(address(0xAAAA));
		vm.deal(address(0xAAAA),funding);
		dots.claimLocation{value:20 ether}(100,100,Dots.Types.Turkey);
		require(dots.claimableBalance() == 20 ether - dots.CLAIM_BASE_PRICE(),"claimable extra balance is not exact.");
		require(address(dots).balance == 20 ether,"contract leaks flow");
		vm.stopPrank();
	}

	function testSecondaryClaim() public
	{
		uint funding = 100 ether;
		//setup for accounts
		vm.startPrank(address(0xCAFE));
		vm.deal(address(0xCAFE),funding);
		vm.deal(address(0xBEEF),funding);

		//0xCAFE makes an exact first claim
		dots.claimLocation{value:dots.CLAIM_BASE_PRICE()}(100,100,Dots.Types.Turkey);
		require(dots.claimableBalance() == 0,"no balance should be available at exact first claims");
		require(address(0xCAFE).balance == funding - dots.CLAIM_BASE_PRICE(),"leak at trail");
		vm.stopPrank();
		
		//0xBEEF captures the location
		vm.startPrank(address(0xBEEF));
		dots.claimLocation{value:dots.CLAIM_BASE_PRICE() + dots.EPSILON()}(100,100,Dots.Types.Greece);
		require(dots.ownerOf(100,100) == address(0xBEEF),"owner misfit 0xBEEF capture");
		vm.stopPrank();	
		//check the claimable balance of 0xCAFE, it should be >= CLAIM_BASE_PRICE.
		vm.startPrank(address(0xCAFE));
		require(dots.claimableBalance() >= dots.CLAIM_BASE_PRICE(), "leak while capture");
		require(dots.ownerOf(100,100) != address(0xCAFE),"owner misfit 0xCAFE");	
		vm.stopPrank();
		//check leaks
		require(address(dots).balance >= 2.01 ether, "leak at the end");
	}
	

	function testWithdraw() public
	{
		uint funding = 100 ether;
		vm.deal(address(0xCAFE),funding);

		//0xCAFE makes 10 ether tx
		vm.startPrank(address(0xCAFE));
		dots.claimLocation{value:10 ether}(100,100,Dots.Types.Turkey);
		require(dots.claimableBalance() == (10 ether) - dots.CLAIM_BASE_PRICE(),"leak extra tx");
		//0xCAFE must be able to claim 9 ether
		dots.claimBalance();
		require(address(0xCAFE).balance == 100 ether - dots.CLAIM_BASE_PRICE(), "leak final tx");
		vm.stopPrank();
	}
	function testFailLowball() public 
	{
		uint funding = 100 ether;	
		vm.deal(address(0xCAFE),funding);
		vm.deal(address(0xFEED),funding);
		vm.startPrank(address(0xCAFE));

		//first claim of unclaimed territory
		dots.claimLocation{value:dots.CLAIM_BASE_PRICE()}(100,100,Dots.Types.Turkey);
		vm.stopPrank();		
		//lowball offer
		vm.startPrank(address(0xFEED));
		dots.claimLocation{value:dots.lotPrice(100,100) + dots.EPSILON() / 2}(100,100,Dots.Types.Turkey);
		vm.stopPrank();
	}
	function testFailWithdraw() public
	{
		uint funding = 100 ether;
		vm.deal(address(0xCAFE),funding);
		vm.startPrank(address(0xCAFE));
		dots.claimBalance();
		vm.stopPrank();
	}

	function testFailUnmatchedCountry() public
	{
		uint funding = 100 ether;
		vm.deal(address(0xCAFE),funding);
		vm.startPrank(address(0xCAFE));
		dots.claimLocation{value:dots.CLAIM_BASE_PRICE()}(100,100,Dots.Types.Nulland);
		vm.stopPrank();
	}

	function testPointDist() public
	{
		uint funding = 100 ether;
		vm.deal(address(0xCAFE),funding);
		vm.startPrank(address(0xCAFE));
		dots.claimLocation{value:dots.CLAIM_BASE_PRICE()}(100,100,Dots.Types.Turkey);
		require(dots.lotCount(Dots.Types.Turkey) == 1,"count mismatch");
		vm.stopPrank();
	}
}
