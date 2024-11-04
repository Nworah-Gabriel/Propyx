import React, { useState } from 'react';
import { ethers } from 'ethers';


const tokenAddress = "YOUR_CONTRACT_ADDRESS_HERE";

const App: React.FC = () => {
  const [walletClient, setWalletClient] = useState<any>(null);
  const [address, setAddress] = useState<string>('');
  const [tokenBalance, setTokenBalance] = useState<string>('');
  const [toAddress, setToAddress] = useState<string>('');
  const [amount, setAmount] = useState<number>(0);

  const getBalance = async () => {
    if (walletClient && address) {
      const provider = new ethers.providers.Web3Provider(walletClient as any);
      const contract = new ethers.Contract(tokenAddress, SimpleTokenContract, provider);
      const balance = await contract.balanceOf(address);
      setTokenBalance(ethers.utils.formatUnits(balance, 18));
    }
  };

  const transferTokens = async () => {
    if (!walletClient || !address) return;
    const provider = new ethers.providers.Web3Provider(walletClient as any);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(tokenAddress, SimpleTokenContract, signer);
    const tx = await contract.transfer(toAddress, ethers.utils.parseUnits(amount.toString(), 18));
    await tx.wait();
    getBalance(); // Refresh balance after transfer
  };

  return (
    <div>
      <h1>Simple Token DApp</h1>
      {isConnected ? (
        <div>
          <p>Connected as: {address}</p>
          <p>Your Token Balance: {tokenBalance}</p>
          <input
            type="text"
            placeholder="Recipient Address"
            value={toAddress}
            onChange={(e) => setToAddress(e.target.value)}
          />
          <input
            type="number"
            placeholder="Amount"
            value={amount}
            onChange={(e) => setAmount(Number(e.target.value))}
          />
          <button onClick={transferTokens}>Transfer Tokens</button>
        </div>
      ) : (
        <p>Please connect your wallet.</p>
      )}
    </div>
  );
};

export default App;
