// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Staking {
    uint public TVL; // tvl стейкинг пула
    uint rewardRate; // per second
    uint reward; // total amount due

    mapping(address => uint) public onStaking; // address => staking amount of this address
    mapping(address => uint) private lockTime; // address => staking time of this address (in minutes)
    mapping(address => uint) private rewards; // address => reward amount for staking

    constructor(uint _rewardPerSecond) {
        rewardRate = _rewardPerSecond;
    }

    // разместить монеты на стейкинг (сумма, срок в минутах)
    function putInStaking(uint _lockTime) public payable {
        require(onStaking[msg.sender] == 0, "you have already staked");
        onStaking[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + _lockTime * 60;
        TVL += msg.value;
        rewards[msg.sender] = msg.value * rewardRate / 100 * _lockTime;
        payable(msg.sender).transfer(msg.value);
    }

    // вывести из стейкинга по окончанию срока
    function pullOutOfStaking() public {
        // require(block.timestamp >= lockTime);
        uint pullOut = onStaking[msg.sender] + reward;
        TVL -= onStaking[msg.sender];
        onStaking[msg.sender] = 0;
        lockTime[msg.sender] = 0;
        rewards[msg.sender] = 0;
        payable(address(this)).transfer(pullOut);
    }

    fallback() external payable {}

    receive() external payable {}
}