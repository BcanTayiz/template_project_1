// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract FlagNft is ReentrancyGuard, Ownable {

//mappings
mapping (uint => userData) public idFull;
mapping (uint =>  int) public countryCount;

enum State{
          Available, Paused, Completed
          }
State private currentState;

uint256 constant public price = 1 ether;

// Define struct
struct userData {

address  exOwner;
address   owner;
uint balanceIdFlag;
uint country;
}



//Transaction
function Transaction( uint  _idFlag,  uint _exCountry, uint _country) external payable  {

    require(currentState == State.Available, "FlagNft: Contest is not available");
    require(msg.sender != address(0), "Address is not  correct");
    require(msg.value > price, "FlagNft: Can't bid lower than minimum bid amount");
    require(_idFlag >= 0 && _idFlag <10000, "FlagNft: Invalid id" );

    if (_exCountry ==0 ) {
        
         countryCount[_exCountry] =10000;
         }

    idFull[_idFlag].exOwner = idFull[_idFlag].owner;
    countryCount[_exCountry] -=1;
    idFull[_idFlag].owner= msg.sender;
    idFull[_idFlag].balanceIdFlag=msg.value;
    idFull[_idFlag].country=_country;
    countryCount[_country] +=1;

    if (countryCount[_country] ==1000){
        currentState = State.Completed;
    }
}

//GetItems from maps
function GetItems( uint _id) public view returns(address , address ,  uint , uint ){

    return (idFull[_id].exOwner, idFull[_id].owner,  idFull[_id].balanceIdFlag, idFull[_id].country);
}

function setState(State newState) external onlyOwner  {
         
                		currentState = newState;
        
								}


}
