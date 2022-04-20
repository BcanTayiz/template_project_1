// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

//Start contract
contract flagNFT {

//Define balances maps : Flag Id-Owner-Balance,  Flag Id -Balances and Flag Id -Country
mapping(uint => mapping (address => uint )) ownerFlagBalances;
mapping(uint => uint) flagBalances;
mapping (uint => string ) flagCountry;

// Define struct
struct userData {

address exOwner;
address owner;
uint idFlag;
uint priceIdFlag;
string country;
}

//Define array from struct
//userData[] public userDatas;

//Transaction
function Transaction( address _exOwner, address _owner, uint _idFlag, uint _priceIdFlag, string memory _country) public {
    //userDatas.push(userData({exOwner: _exOwner, owner: _owner, idFlag:_idFlag, priceIdFlag: _priceIdFlag, country: _country}));
    ownerFlagBalances[_idFlag][_owner]=_priceIdFlag;
    flagBalances[_idFlag]=_priceIdFlag;
    flagCountry[_idFlag]=_country;
    ownerFlagBalances[_idFlag][_owner] -=_priceIdFlag;
    ownerFlagBalances[_idFlag][_exOwner] +=_priceIdFlag;
}

//GetItems from maps
function GetItems( uint _id) public view returns(uint, string memory){
    return (flagBalances[_id], flagCountry[_id]);
}

}
