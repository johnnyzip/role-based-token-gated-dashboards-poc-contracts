import { ethers } from "hardhat";

async function main() {
  const rpc = process.env.SEPOLIA_RPC || "https://11155111.rpc.thirdweb.com";
  const pk = process.env.DEPLOYER_PRIVATE_KEY;

  if (!pk) throw new Error("Missing DEPLOYER_PRIVATE_KEY in contracts/.env");
  const provider = new ethers.JsonRpcProvider(rpc);
  const wallet = new ethers.Wallet(pk, provider);

  const NAME = "Project Access";
  const SYMBOL = "PACCESS";
  const BASE_URI = "https://example.com/metadata/{id}.json";
  const ADMIN = await wallet.getAddress();

  console.log("Deploying with:", ADMIN);

  // getContractFactory can take a signer; pass our wallet so we don't rely on hardhat accounts[]
  const Factory = await ethers.getContractFactory("ProjectAccess1155", wallet);
  const contract = await Factory.deploy(NAME, SYMBOL, BASE_URI, ADMIN);
  await contract.waitForDeployment();

  console.log("ProjectAccess1155 deployed to:", await contract.getAddress());
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
// npx hardhat run scripts/deploy.ts --network sepolia