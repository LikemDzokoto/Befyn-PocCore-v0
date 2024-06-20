import { ethers } from "hardhat";
import * as dotenv from "dotenv";
import { Etherscan } from "@nomicfoundation/hardhat-verify/etherscan";
import { sleep } from "@nomicfoundation/hardhat-verify/internal/utilities";

dotenv.config();

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const balance = await deployer.getBalance();
  console.log("Account balance:", balance.toString());

  const MATURITY_PERIOD = 30 * 24 * 60 * 60; // 30 days in seconds
  const CLAIM_AMOUNT = ethers.parseEther("1.0"); // 1 Ether

  const BefynInsurance = await ethers.getContractFactory("BefynInsurance");
  const befynInsurance = await BefynInsurance.deploy(MATURITY_PERIOD, CLAIM_AMOUNT);

  await befynInsurance.waitForDeployment();

  const { ...tx } = befynInsurance.deploymentTransaction()?.toJSON();
  tx.data = await befynInsurance.getAddress();

  console.log(`BefynInsurance deployed to ${JSON.stringify(tx, null, 2)}`);

  // Verify contract on Etherscan
  // await Etherscan.verify(befynInsurance.address);

  // Wait for the deployment to be verified on Etherscan
  await sleep(30000); // 30 seconds

  console.log("BefynInsurance deployment verified on Etherscan");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});