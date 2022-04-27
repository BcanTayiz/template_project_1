pragma solidity ^0.8.11;

import "forge-std/Test.sol";
import "../DotsV2.sol";


contract DotsV2Test is Test
{
	DotsV2 dv2;

	function setUp() public
	{
		dv2 = new DotsV2();
	}

	function testFirstClaimTransaction() public
	{
		dv2.Transaction{value:1.1 ether}(1,dv2.GetSingle(1).country,1);
	}
	function testSecondaryClaimTransaction() public
	{
		vm.deal(address(0xCAFE),100 ether);
		vm.deal(address(0xBEEF),100 ether);

		vm.startPrank(address(0xCAFE));
		dv2.Transaction{value:1.1 ether}(1,dv2.GetSingle(1).country,1);
		vm.stopPrank();

		vm.startPrank(address(0xBEEF));
		dv2.Transaction{value:1.3 ether}(1,dv2.GetSingle(1).country,2);
		vm.stopPrank();
	}
}
