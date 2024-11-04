// src/index.tsx
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import { WalletProvider } from './components/walletConfig';
import '@rainbow-me/rainbowkit/styles.css';

ReactDOM.render(
  <WalletProvider>
    <App />
  </WalletProvider>,
  document.getElementById('root')
);
