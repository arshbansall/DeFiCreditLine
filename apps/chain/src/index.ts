import "dotenv/config";
import { ethers } from "ethers";

async function main() {
  const rpcUrl = process.env.RPC_URL!;
  const provider = new ethers.JsonRpcProvider(rpcUrl);

  console.log("Connected to RPC:", rpcUrl);

  // TODO: load ABI + contract address
  // TODO: contract.on("Draw", ...) and write to Postgres
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
