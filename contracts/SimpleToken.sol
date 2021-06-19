// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.0;

// <500 : 8% APY
// 500-1000 : 10% APY
// 1000-1500 : 15% APY
// >1500 : 25% APY

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract SimpleTokenBasic is ERC20{
     constructor () ERC20("SimpleToken", "ST") {
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }
}
