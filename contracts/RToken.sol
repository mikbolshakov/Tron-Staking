// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RToken is ERC20 {
    constructor() ERC20("Rewarding", "RT", 1000) {}
}