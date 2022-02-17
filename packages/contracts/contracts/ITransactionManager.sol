pragma solidity ^0.8.0;

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
