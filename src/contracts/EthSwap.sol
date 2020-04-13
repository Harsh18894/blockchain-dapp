pragma solidity ^0.5.0;

import "./Token.sol";


contract EthSwap {
    string public name = "EthSwap Instant Exchange";
    Token public token;
    uint256 public rate = 100;

    event TokenPurchased(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );

    event TokenSold(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );

    constructor(Token _token) public {
        token = _token;
    }

    // 1 ETH = 100 DApp tokens
    function buyTokens() public payable {
        // Redemption rate  = # of tokens they receive for 1 ether
        // Amount of Ethereum * Redemption Rate

        // Number to tokens to buy
        uint256 tokenAmount = msg.value * rate;

        // Require that EthSwap has enough tokens
        require(
            token.balanceOf(address(this)) >= tokenAmount,
            "EthSwap does not have enough tokens"
        );

        token.transfer(msg.sender, tokenAmount);

        // Emit an event
        emit TokenPurchased(msg.sender, address(token), tokenAmount, rate);
    }

    function sellTokens(uint256 _amount) public {
        // User can't sell more tokens than they have
        require(token.balanceOf(msg.sender) >= _amount);

        // Calculate the amount of ether to redeem
        uint256 etherAmount = _amount / rate;

        require(
            address(this).balance >= etherAmount,
            "EthSwap does not have enough Ether"
        );

        // Perform sale
        token.transferFrom(msg.sender, address(this), _amount);
        msg.sender.transfer(etherAmount);

        emit TokenSold(msg.sender, address(token), _amount, rate);
    }
}
