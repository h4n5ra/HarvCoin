pragma solidity ^0.4.20;

contract HarvCoin{
    
    string public constant symbol = "HSH";
    string public constant name = "HarvCoin";
    uint8 public constant decimals = 0;
    uint public constant _totalSupply = 1000000;
    address private contractOwner;
    
    mapping(address => uint) coinBase;
    mapping(address => mapping(address => uint)) allowed;
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    
    /* gives all tokens to the contract creator*/
    function HarvCoin() public{
        contractOwner = msg.sender;
        coinBase[contractOwner] = _totalSupply;
    }
    
    /* returns the total number of coins ever*/
    function totalSupply() public pure returns (uint){
        return _totalSupply;
    }
    
    /* returns the balance of an address */
    function balanceOf(address tokenOwner) public view returns (uint){
        return coinBase[tokenOwner];
    }
    
    /* ensures the sender of tokens has enough to send the amount he/she wishes to send*/
    modifier hasEnough(address sender, uint value){
        uint delta = coinBase[sender] - value;
        require(delta >= 0);
        _;
    }
    
    /* ensures the value of tokens wanting to be sent is non-negative*/ 
    modifier isPositive(uint value){
        require(value > 0);
        _;
    }
    
    /* ensures there is overflow on the receiver's side*/
    modifier overflows(address to, uint value){
        uint delta = coinBase[to] + value;
        require(delta > coinBase[to]);
        _;
    }
    
    /* allows an adddress to transfer coins to another address*/
    function transfer(address to, uint tokens) isPositive(tokens) hasEnough(msg.sender, tokens) overflows(to, tokens) public returns (bool){
        coinBase[msg.sender] -= tokens;
        coinBase[to] += tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
        
    }
    
    /* returns the amount of coins the address can send */
    function allowance(address tokenOwner, address spender) public view returns (uint) {
        return allowed[tokenOwner][spender];
    }
    
    /*gives permission to address to transfer tokens on the senders behalf*/
    function approve(address spender, uint tokens) public returns (bool) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    /* transfer tokens from another address the user as approval from to a specified address*/
    function transferFrom(address from, address to, uint tokens) isPositive(tokens) hasEnough(from, tokens) overflows(to, tokens) public returns (bool success){
        coinBase[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        coinBase[to] += tokens;
        emit Transfer(from, to, tokens);
        return true;
    }
    
}
