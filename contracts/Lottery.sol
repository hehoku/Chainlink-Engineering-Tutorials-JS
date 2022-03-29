// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {randomness_interface} from "./interfaces/randomness_interface.sol";
import {governance_interface} from "./interfaces/governance_interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract Lottery is VRFConsumerBase, Ownable {
  address payable[] public players;
  address payable public recentWinner;

  uint256 public usdEntryFee;
  AggregatorV3Interface internal ethUsdPriceFeed;

  uint256 public randomness;

  uint256 public fee;
  bytes32 public keyhash;
  bytes32 public requestId;

  event RequestedRandomness(bytes32 requestId);

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
  constructor(
    address _vrfCoordinator,
    address _link,
    uint256 _fee,
    bytes32 _keyhash
  ) VRFConsumerBase(_vrfCoordinator, _link) {
    usdEntryFee = 50 * (10**18);
    ethUsdPriceFeed = AggregatorV3Interface(
      0x0715A7794a1dc8e42615F059dD6e406A6594651A
    );
    lottery_state = LOTTERY_STATE.CLOSED;
    fee = _fee;
    keyhash = _keyhash;
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

  function endLottery() public onlyOwner {
    lottery_state = LOTTERY_STATE.CALCULATING_WINNER;
    requestId = requestRandomness(keyhash, fee);
    emit RequestedRandomness(requestId);
  }

  function fulfillRandomness(bytes32 _requestId, uint256 _randomness)
    internal
    override
  {
    require(
      lottery_state == LOTTERY_STATE.CALCULATING_WINNER,
      "You aren't there yet"
    );
    require(_randomness > 0, "random not found");
    uint256 indexOfWinner = _randomness % players.length;
    recentWinner = players[indexOfWinner];
    recentWinner.transfer(address(this).balance);

    players = new address payable[](0);
    lottery_state = LOTTERY_STATE.CLOSED;
    randomness = _randomness;
    requestId = _requestId;
  }
}
