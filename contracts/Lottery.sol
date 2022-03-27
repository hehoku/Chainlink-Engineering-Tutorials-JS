// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import { randomness_interface } from "./interfaces/randomness_interface.sol";
import { governance_interface } from "./interfaces/governance_interface.sol";

contract Lottery {
  address payable[] public players;
  uint256 public usdEntryFee;
  AggregatorV3Interface internal ethUsdPriceFeed;

  /**
   * Network: Mumbai Testnet
   * Aggregator: MATIC/USD
   * Address: 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada
   */
  constructor() public {
    usdEntryFee = 50 * (10**18);
    ethUsdPriceFeed = AggregatorV3Interface(
      0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada
    );
  }

  // @notice Register a player
  function enter() public payable {
    // $50 USD entry fee
    players.push(msg.sender);
  }

  function getEntranceFee() public view returns (uint256) {
    (, int256 price, , , ) = ethUsdPriceFeed.latestRoundData();

    uint256 adjustedPrice = uint256(price) * 10**10;
    uint256 costToEnter = usdEntryFee / adjustedPrice;
    return costToEnter;
  }
}
