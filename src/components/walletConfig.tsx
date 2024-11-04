// src/components/walletConfig.tsx
import React from 'react';
import { configureChains, createConfig, WagmiConfig } from 'wagmi';
import { mainnet, goerli } from 'wagmi/chains';
import { publicProvider } from 'wagmi/providers/public';
import {
  connectorsForWallets,
  RainbowKitProvider,
} from '@rainbow-me/rainbowkit';

const { chains, publicClient } = configureChains(
  [mainnet, goerli],
  [publicProvider()]
);

const connectors = connectorsForWallets([{ groupName: 'Popular', wallets: [] }]);

const wagmiConfig = createConfig({
  autoConnect: true,
  connectors,
  publicClient,
});

export const WalletProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <WagmiConfig config={wagmiConfig}>
    <RainbowKitProvider chains={chains}>
      {children}
    </RainbowKitProvider>
  </WagmiConfig>
);
