// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.0;

// <500 : 8% APY
// 500-1000 : 10% APY
// 1000-1500 : 15% APY
// >1500 : 25% APY

import "./NordToken.sol";
import "./SimpleToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol";

contract Stake is Ownable, ReentrancyGuard{
    using Address for address;
    using SafeMath for uint256;
    
    NordTokenBasic public nordtoken;
    SimpleTokenBasic public simpletoken;
    uint Rate;
    uint public APY;
    uint ETHMantissa = 1 * 10 ** 18;
    // Blocks per day
    uint BPD = 6570;
    //Days per year
    uint DPY = 365;
    uint public allowance;
    
    constructor(address _nordtoken, address _simpletoken){
        nordtoken = NordTokenBasic(_nordtoken);
        simpletoken = SimpleTokenBasic(_simpletoken);
    }

    function getAPY(uint256 amount) public returns (bool){
        if(amount<500)
            Rate = 8 * ETHMantissa;
        else if(amount>=500 && amount<1000)
            Rate = 10 * ETHMantissa;
        else if(amount>=1000 && amount<1500)
            Rate = 15 * ETHMantissa;
        else
            Rate = 25 * ETHMantissa;
         APY = ((((Rate / ETHMantissa * BPD + 1) ^ DPY)) - 1) * 100;
         require(APY>0, "APY is not greater than 0");
         return true;
    }
    
    //Stake simpletoken into contract in return for equal amount of nordtoken
    //'amount' refers to the amount to be staked
    
    function supplyAsset(uint256 amount) public returns (bool){
        require(amount>0, "Please enter a valid amount");
        require(simpletoken.balanceOf(msg.sender)>amount, "You do not have enough tokens to stake");
        simpletoken.transferFrom(msg.sender, address(this), amount);
        nordtoken.mint(msg.sender, amount);
        return true;
    }
    
    //On redeeming the staked simpletoken, get an additional reward dependent on the amount staked.
    //'amount' refers to the amount to be redeemed
    
    function redeemAsset(uint256 amount) public returns (bool){
        require(amount>0, "Please enter a valid amount");
        require(nordtoken.balanceOf(msg.sender)>amount, "You have not staked enough tokens");
        nordtoken.burn(msg.sender, amount);
        getAPY(amount);
        uint newAmount = amount + APY;
        simpletoken.approve(address(this), newAmount);
        simpletoken.transferFrom(address(this), msg.sender, newAmount);
        return true;
    }
    

    
}