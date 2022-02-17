//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "hardhat/console.sol";
import {ILendingPool} from "@aave/protocol-v2/contracts/interfaces/ILendingPool.sol";

interface ITransactionManager {
    struct CallParams {
        address recipient;
        address callTo;
        bytes callData;
        uint32 originDomain;
        uint32 destinationDomain;
    }

    struct PrepareArgs {
        CallParams params;
        address transactingAssetId; // Could be adopted, local, or wrapped
        uint256 amount;
    }

    function prepare(PrepareArgs calldata _args)
        external
        payable
        returns (bytes32);
}


interface ICrossDomainDepositMiddleware {
    function deposit(
        address asset,
        address pool,
        address onBehalfOf
    ) external;
}

contract CrossDomainDeposit {
    ITransactionManager public immutable transactionManager;

    mapping (uint32 => address) public pools;

    constructor(ITransactionManager _transactionManager, uint32[] memory _domains, address[] memory _pools) public {
        transactionManager = _transactionManager;
        for (uint i = 0; i < _domains.length; i++) {
            pools[_domains[i]] = _pools[i];
        }
    }

    function deposit(
        address token,
        uint32 originDomain,
        uint32 destinationDomain,
        uint256 amount
    ) external {
        address pool = pools[destinationDomain];
        require(pool != address(0), "Pool does not exist");

        bytes4 selector = bytes4(keccak256("deposit(address,address,address)"));

        ITransactionManager.CallParams memory callParams = ITransactionManager.CallParams({
            recipient: msg.sender,
            callTo: pool,
            callData: abi.encodeWithSelector(selector, token, pool, msg.sender),
            originDomain: originDomain,
            destinationDomain: destinationDomain
        });

        ITransactionManager.PrepareArgs memory prepareArgs = ITransactionManager.PrepareArgs({
            params: callParams,
            transactingAssetId: token,
            amount: amount
        });

        transactionManager.prepare(prepareArgs);
    }
}
