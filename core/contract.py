import json
from web3 import Web3
from web3.middleware import ExtraDataToPOAMiddleware
from dotenv import load_dotenv


# Connect to the Ethereum network using Infura as the provider
w3 = Web3(Web3.HTTPProvider("https://sepolia.infura.io/v3/62ec278d3eb941748d8503e6cadaf637"))

# Inject middleware for Proof of Authority (if using a PoA network like Rinkeby)
w3.middleware_onion.inject(ExtraDataToPOAMiddleware, layer=0)

# Check if connection is successful
if not w3.is_connected():
    raise ConnectionError("Failed to connect to the Ethereum network via Infura")

# Load contract ABI and address
CONTRACT_ADDRESS = "0xF7cC1C44C3116C4077180Eced3c24DE411C3B653"
with open("core/Propyx_ABI.json") as f:
    contract_abi = json.load(f)


# Initialize the contract
contract = w3.eth.contract(address=CONTRACT_ADDRESS, abi=contract_abi)

OWNER_ADDRESS = "0x2d122fEF1613e82C0C90f443b59E54468e16525C"
