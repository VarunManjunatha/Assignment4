//0x97b6a09f6F5E8b7C862b07f917B41cF7debB139F

pragma solidity ^0.8.0;

contract Subscription {
    enum State {inactive, active}
    State public state;
    
    address payable public Varun;
    uint256 public subscriptionFee;
    
    mapping(address => uint256) public subscriptions;
    
    modifier onlyVarun() {
        require(msg.sender == Varun, "Only Varun can call this function.");
        _;
    }
    
    modifier onlyWhileActive() {
        require(state == State.active, "Subscription service is not currently active.");
        _;
    }
    
    constructor(uint256 _subscriptionFee) {
        Varun = payable(msg.sender);
        subscriptionFee = _subscriptionFee;
        state = State.inactive;
    }
    
    function activateSubscription() public onlyVarun {
        state = State.active;
    }
    
    function subscribe(uint256 _periodMonths) public payable onlyWhileActive {
        require(_periodMonths > 0, "Subscription period must be greater than zero.");
        uint totalFee = subscriptionFee * _periodMonths;
        require(msg.value == totalFee, "Incorrect subscription fee.");
        subscriptions[msg.sender] += block.timestamp + (_periodMonths * 30 days);
    }
    
    function checkSubscription(address subscriber) public view returns (bool) {
        return subscriptions[subscriber] >= block.timestamp;
    }
    
    function withdraw() public onlyVarun {
        Varun.transfer(address(this).balance);
    }
}