import { ethers } from "hardhat";
import * as dotenv from "dotenv";
import { Etherscan } from "@nomicfoundation/hardhat-verify/etherscan";
import { sleep } from "@nomicfoundation/hardhat-verify/internal/utilities";
dotenv.config();
async function main() {
  const ONE_HOUR = 60 * 60;
  const ONE_DAY = ONE_HOUR * 24;
  const ONE_WEEK = ONE_DAY * 7;

  

  const shadow = await ethers.deployContract("BefynInsurance");

  await shadow.waitForDeployment();

  const { ...tx } = shadow.deploymentTransaction()?.toJSON();
  tx.data = await shadow.getAddress();

  console.log(`deployed to ${JSON.stringify(tx, null, 2)}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});