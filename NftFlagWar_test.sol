pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../Dots.sol";
import "../Helper.sol";

contract DTest is Test{
    Dots dots;
    Dots d;
    Helper h;
    
    address alice;
    address bob;
  
    uint public initial_balance = 2500 ether;

    function setUp() public{
        dots = new Dots(50,50);
        //fund the addresses
        alice = payable(address(0xAAAA));
        vm.deal(alice, initial_balance);
        bob = payable(address(0xBBBB));
        vm.deal(bob,initial_balance);
    //     vm.startPrank(alice);
    //     for(uint i = 0 ; i < dots.x_width();i++){
    //         for(uint j = 0 ; j < dots.y_width(); j++){
    //             dots.claimLocation{value:1 ether}(i,j,Dots.Types.Brazil);
    //         }
    //    }
    }

    /// Fail if no value present
    function testFailNoValueCapture() public{
        vm.startPrank(alice);
        dots.claimLocation(20, 20, Dots.Types.Turkey);
    }

    /// Fail if out of bounds
    function testFailOutOfBounds() public{
        vm.startPrank(alice);
        dots.claimLocation{value:2 ether}(10000,100000,Dots.Types.Turkey);
    }

    /// First claim fail if no more than 1 ether
    function testFailLowerBound() public{
        vm.startPrank(alice);
        dots.claimLocation{value:dots.CLAIM_BASE_PRICE()/2}(20, 20, Dots.Types.Turkey);
    }

    /// Pass if exact value sent for first purchase
    function testExactFirstPricePaid() public{
        vm.startPrank(alice);
        dots.claimLocation{value:dots.CLAIM_BASE_PRICE()}(20, 20, Dots.Types.Turkey);
    }
    
    function testSecondaryPurchase() public{
        uint first_price = 1.2 ether;
        uint delta = 0.4 ether;       

        vm.startPrank(alice);
        dots.claimLocation{value:first_price}(20, 20, Dots.Types.Turkey);
        vm.stopPrank();

        vm.startPrank(bob);
        dots.claimLocation{value:first_price+(2*delta)}(20, 20, Dots.Types.UnitedStates);
        vm.stopPrank();

        console.log(address(dots).balance);
        uint expected_balance = ((first_price)/1000) + ((first_price + 2 * delta)/1000);
        require(address(dots).balance == expected_balance,"leak at flow");

    }

    function testClaimOwnerCut() public
    {
        vm.startPrank(alice);
        d = new Dots(50,50);
        vm.deal(address(d), initial_balance);
        d.setState(Dots.State.Completed);
        
        uint balanceBefore = address(alice).balance;
        d.claimOwnerCut();
        uint balanceAfter = address(alice).balance;
        uint required_balance = (balanceBefore * 15)/100;
        require(balanceAfter - balanceBefore == required_balance, "leak while owner cut");
    }

    function testFailClaimOwnerCut() public
    {
        vm.startPrank(alice);
        d = new Dots(50,50);
        d.claimOwnerCut();
    }

    function testFailClaimOwnerCutNonOwner() public{
        vm.startPrank(alice);
        d = new Dots(50,50);
        vm.stopPrank();
        d.claimOwnerCut();
    }
    function testFailRecoverBalance() public {
        vm.startPrank(alice);
        vm.deal(alice, 100 ether);
        d = new Dots(50,50);
        h = new Helper(d);
        vm.deal(address(h), 100 ether);

        //h needs a refund but no mechanism provided for it
        h.callClaimLocation();
        d.claimLocation{value:12 ether}(100,100,Dots.Types.Turkey);
      
        console.log(address(d).balance);
        console.log(address(h).balance);
        console.log(alice.balance);
    }

    function testSlate() public {
       vm.startPrank(alice);
       vm.deal(alice, 250000 ether); 
    //hardcoded values since solidity arrays suck
    
       Dots.Types[50][50] memory map = dots.returnSlate();
       for(uint i = 0 ; i < dots.x_width();i++){
        for(uint j = 0 ; j < dots.y_width(); j++){
            require(map[i][j] == Dots.Types.Nulland,"mismatch?");
        }
       }
    }
}
