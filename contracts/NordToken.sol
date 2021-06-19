// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.0;

// <500 : 8% APY
// 500-1000 : 10% APY
// 1000-1500 : 15% APY
// >1500 : 25% APY

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract NordTokenBasic is ERC20{
    address admin;
     constructor () ERC20("NordToken", "NT") {
         admin = msg.sender;
         
    }
    function mint(address to, uint amount) external {
    require(msg.sender == admin, 'only admin');
    _mint(to, amount);
  }

  function burn(address owner, uint amount) external {
    require(msg.sender == admin, 'only admin');
    _burn(owner, amount);
  }
}
