import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { constants } from "ethers";

const chainConfigs = [
  {
    chainId: 1337,
    pool: constants.AddressZero,
    domain,
  },
];

/**
 * Hardhat task defining the contract deployments for nxtp
 *
 * @param hre Hardhat environment to deploy to
 */
const func: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
): Promise<void> => {
  const chainId = await hre.getChainId();
  console.log("chainId: ", chainId);

  const { deployer } = await hre.getNamedAccounts();
};
export default func;
