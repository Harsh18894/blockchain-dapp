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
}
