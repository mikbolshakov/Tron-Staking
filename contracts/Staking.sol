// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Staking {
    IERC20 rewardsToken;
    IERC20 stakingToken;

    uint public TVL; // tvl стейкинг пула
    uint rewardRate = 10;
    uint reward;
    uint lastUpdateTime;
    uint rewardPerTokenStored;
    uint lockTime; // lock time in minutes
    uint onStaking;

    mapping(address => uint) userRewardPerTokenPaid;
    mapping(address => uint) public rewards;
    mapping(address => uint) public balances;
    mapping(address => uint) private onStaking;

    modifier updateReward(address _account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;
        rewards[_account] = earned(_account);
        userRewardPerTokenPaid[_account] = rewardPerTokenStored;
        _;
    }

    // разместить монеты на стейкинг (сумма, срок в минутах)
    function putInStaking(uint _amount, uint _lockTime) public payable {
        onStaking[msg.sender] = _amount;
        lockTime = block.timestamp + _lockTime * 60;
        TVL += _amount;
        reward = _amount * rewardRate / 100;
        stakingToken.transferFrom(msg.sender, balance(this), _amount);
    }

    // вывести из стейкинга по окончанию срока
    function pullOutOfStaking() public {
        require(block.timestamp >= lockTime);
        TVL -= onStaking[msg.sender];
        onStaking[msg.sender] = 0;
        uint pullOut = onStaking[msg.sender] + reward
        stakingToken.transfer(msg.sender, pullOut);
    }

    // function getReward() external updateReward(msg.sender) {
    //     uint reward = rewards[msg.sender];
    //     rewards[msg.sender] = 0;
    //     rewardsToken.transfer(msg.sender, reward);
    // }

    // function rewardPerToken() public view returns(uint) {
    //     if(totalSupply == 0) {
    //         return 0;
    //     }

    //     return rewardPerTokenStored + (
    //         rewardRate * (block.timestamp - lastUpdateTime)
    //         ) * 1e18 / totalSupply;
    // }

    // function earned(address _account) public view returns(uint) {
    //     return (
    //         balances[_account] * (
    //         rewardPerToken() - userRewardPerTokenPaid[_account]
    //         ) / 1e18
    //     ) + rewards[_account];
    // }
    

    // вывести из стейкинга по окончанию срока
    // проценты в конце срока при выводе из стейкинга 

    // список вкладчиков (адрес, сумма, дата начала и окончания стейкинга)


    // настройки: % начисления в минуту, тариф (3, 5, 10 мин), адрес владельца для начисления процентов, сумма комиссии
}