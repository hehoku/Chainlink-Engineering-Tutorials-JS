// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import { randomness_interface } from "./interfaces/randomness_interface.sol";
import { governance_interface } from "./interfaces/governance_interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is Ownable {
  address payable[] public players;
  uint256 public usdEntryFee;
  AggregatorV3Interface internal ethUsdPriceFeed;

  enum LOTTERY_STATE {
    OPEN,
    CLOSED,
    CALCULATING_WINNER
  }
  LOTTERY_STATE public lottery_state;

  /**
   * https://docs.chain.link/docs/matic-addresses/#Mumbai%20Testnet
   * Network: Mumbai Testnet
   * Aggregator: ETH/USD
   * Address: 0x0715A7794a1dc8e42615F059dD6e406A6594651A
   */
  constructor() {
    usdEntryFee = 50 * (10**18);
    ethUsdPriceFeed = AggregatorV3Interface(
      0x0715A7794a1dc8e42615F059dD6e406A6594651A
    );
    lottery_state = LOTTERY_STATE.CLOSED;
  }

  // @notice Register a player
  function enter() public payable {
    require(lottery_state == LOTTERY_STATE.OPEN);
    // $50 USD entry fee
    require(msg.value >= getEntranceFee(), "Not enough ETH");
    players.push(payable(msg.sender));
  }

  function getEntranceFee() public view returns (uint256) {
    // price in eth/usd with 10 ** 8
    (, int256 price, , , ) = ethUsdPriceFeed.latestRoundData();

    uint256 adjustedPrice = uint256(price) * 10**10; // now it'is 18 decimals
    uint256 costToEnter = (usdEntryFee * 10**18) / adjustedPrice;
    // return wei
    return costToEnter;
  }

  function startLottery() public onlyOwner {
    require(
      lottery_state == LOTTERY_STATE.CLOSED,
      "Can't start a new lottery yet"
    );
    lottery_state = LOTTERY_STATE.OPEN;
  }
}
