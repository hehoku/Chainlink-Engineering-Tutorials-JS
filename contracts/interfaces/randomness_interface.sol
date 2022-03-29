// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface randomness_interface {
  function randomNumber(uint256) external view returns (uint256);

  function getRandom(uint256, uint256) external;
}
