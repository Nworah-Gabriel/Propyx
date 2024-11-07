// Script for connecting wallet
	document.addEventListener("DOMContentLoaded", function() {
		async function connectWallet() {
			const button = document.getElementById("connectWalletButton");

			if (typeof window.ethereum !== 'undefined') {
				try {
					// Request account access if needed
					const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
					
					// Get the connected wallet address
					const address = accounts[0];
					
					// Replace the button text with the user's address
					button.textContent = `${address.substring(0, 6)}...${address.substring(address.length - 4)}`;
					
				} catch (error) {
					console.error("Failed to connect wallet:", error);
				}
			} else {
				alert("MetaMask or another Ethereum-compatible wallet not detected!");
			}
		}

		// Attach event listener to the button
		document.querySelector('.ct-button').addEventListener('click', function(event) {
			event.preventDefault();  // Prevent page reload
			connectWallet();
		});
	});
