// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Staking {
    IERC20 public token;
    uint public totalPoolAmount; 
    uint rewardRatePerMinute;

    mapping(address => uint) public stakingAmount; // address => staking amount of this address
    mapping(address => uint) private lockTime; // address => number of minutes in staking
    mapping(address => uint) private endTimeOfStaking; // address => end time of staking
    mapping(address => uint) public rewardPerMinute; // address => reward amount in one minute

    event NewDepositor(address sender, uint amount, uint startsAt, uint endsAt);

    constructor(uint _rewardRatePerMinute, IERC20 _token) {
        token = _token;
        rewardRatePerMinute = _rewardRatePerMinute;
    }

    function putInStaking(uint _amount, uint _lockTime) public payable {
        require(stakingAmount[msg.sender] == 0, "already in staking");
        totalPoolAmount += _amount;
        stakingAmount[msg.sender] = _amount;
        lockTime[msg.sender] = _lockTime;
        endTimeOfStaking[msg.sender] = block.timestamp + _lockTime * 60;
        rewardPerMinute[msg.sender] = _amount * rewardRatePerMinute / 100;
        token.transferFrom(msg.sender, address(this), _amount);

        emit NewDepositor(msg.sender, _amount, block.timestamp, lockTime[msg.sender]);
    }

    // вывести из стейкинга по окончанию срока
    function pullOutOfStaking() public {
        require(block.timestamp >= endTimeOfStaking[msg.sender], "Staking time is not over");
        uint pullOut = stakingAmount[msg.sender] + rewardPerMinute[msg.sender] * lockTime[msg.sender];
        totalPoolAmount -= stakingAmount[msg.sender];
        stakingAmount[msg.sender] = 0;
        endTimeOfStaking[msg.sender] = 0;
        rewardPerMinute[msg.sender] = 0;
        lockTime[msg.sender] = 0;
        token.transfer(msg.sender, pullOut);
    }

    fallback() external payable {}

    receive() external payable {}
}

/*
Написать смарт-контракт в сети Tron для стейкинга TRX.

Смарт контракт должен содержать следующие методы:
+ Разместить монеты на стейкинг (сумма, срок в минутах)
+ Освобождение монет из стейкинга по окончании срока
-+ Вывести список вкладчиков (кошельки, суммы, дата вклада, дата завершения сетйкинга)
    // вывел на фронте через событие
+ Вывести общий баланс в стейкинге

Смарт контракт должен содержать блок настроек:
- процент начислений за стейкинг из расчета % / минуту,
-+ список тарифов по времени (3 минуты, 5 минут, 10 минут), 
    // я же правильно понял - суть в том, чтобы дублировать фнукции со строгим значением _lockTime
- адрес кошелька владельца для начисления процентов, 
- сумма комиссии
Начисление процентов осуществляется в конце срока депозита при выводе пользователю на
кошелек

Опубликовать в тестнете сети tron, верифицировать.. Код покрыть тестами.
Для проверки и оценки результата необходимо предоставить:
- Адрес контракта в сети
- Ссылку на GIT репозиторий для проверки кода
- Описание структурной схемы проекта (xmind)
- Описание работы и методов подключения
*/