// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SToken is ERC20 {
    constructor() ERC20("Staking", "ST", 10000) {}
}