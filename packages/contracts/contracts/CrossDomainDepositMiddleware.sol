//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "hardhat/console.sol";
import {ILendingPool} from "@aave/protocol-v2/contracts/interfaces/ILendingPool.sol";

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract CrossDomainDepositMiddleware {
    function deposit(
        address asset,
        address pool,
        address onBehalfOf
    ) external {
        IERC20 token = IERC20(asset);
        uint256 amount = token.balanceOf(msg.sender);
        token.transferFrom(msg.sender, address(this), amount);

        ILendingPool(pool).deposit(asset, amount, onBehalfOf, 0);
    }
}
