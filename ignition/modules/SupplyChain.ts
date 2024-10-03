import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";



const SupplyChainModule = buildModule("SupplyChainModule", (m) => {
  

  const SupplyChain = m.contract("SupplyChain");

  return { SupplyChain };
});

export default SupplyChainModule;
