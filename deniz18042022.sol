// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol";
//nonReentrant() çağırılacak

contract Dots
{
    enum Types{Nulland,Argentina, Australia, Brazil, Canada, China, France, Germany,India, Indonesia, Italy, Japan, SouthKorea, Mexico,  Russia,  SaudiArabia, SouthAfrica,  Turkey, Ukraine, UnitedKingdom, UnitedStates }

  
    uint immutable public CLAIM_BASE_PRICE = 1 ether;
    //const public  BASE_FEE = new Percent(JSBI.BigInt(30), JSBI.BigInt(10000));
    address immutable public treasury =0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    uint price_paid;
         
    mapping (address=>uint) balances;
    mapping (uint => Dot) lots;

    struct Dot
    {
        address owner;
        Types country; 
        uint last_price;
    }

   

    function claimLocation(uint id, Types country) public payable
    {
        require(Types.Nulland <= country && country <= Types.Turkey, "Undefined Country");

        if(lots[id].owner == address(0))
        {
          
            require(msg.value >= CLAIM_BASE_PRICE, "Insufficient Value");
            balances[msg.sender] += msg.value;
            price_paid == msg.value;
        }
        else
        {
            require(msg.value >= lots[id].last_price, "Your price bid is less than actual price");
            price_paid = msg.value;
            balances[lots[id].owner] = lots[id].last_price;
        }
        lots[id].last_price = price_paid;
        lots[id].owner = msg.sender;
        lots[id].country = country;
    }
    function claimBalance()  public 
    {
        require(balances[msg.sender] > 0,"no claimable balance for address");
        // uint amount = balances[msg.sender]-  balances[msg.sender]*fee ;
        (bool success, ) = payable(msg.sender).call{value:amount}("");
        require(success,"failed transfer");
                balances[msg.sender] -= amount;
    }
}
