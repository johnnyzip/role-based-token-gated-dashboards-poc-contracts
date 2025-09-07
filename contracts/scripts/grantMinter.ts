import { ethers } from "hardhat";

// Usage: npx hardhat run scripts/grantMinter.ts --network sepolia
// Requires: CONTRACT=<address> NEW_MINTER=<address> in env
async function main() {
  const contractAddr = process.env.CONTRACT;
  const newMinter = process.env.NEW_MINTER;
  if (!contractAddr || !newMinter) throw new Error("Set CONTRACT and NEW_MINTER env vars");

  const factory = await ethers.getContractFactory("ProjectAccess1155");
  const contract = factory.attach(contractAddr);

  const role = ethers.keccak256(ethers.toUtf8Bytes("MINTER_ROLE"));
  const tx = await contract.grantRole(role, newMinter);
  await tx.wait();
  console.log("Granted MINTER_ROLE to", newMinter);
}

main().catch((e) => { console.error(e); process.exit(1); });
