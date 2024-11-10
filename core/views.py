from django.shortcuts import render
from django.http import JsonResponse
from .contract import w3, contract, OWNER_ADDRESS
import requests
from urllib.parse import quote

# Utility function to build a transaction
def build_transaction(tx):
    tx_data = {
        'nonce': w3.eth.get_transaction_count(OWNER_ADDRESS),
        'gas': 2000000,
        'gasPrice': w3.to_wei("20", "gwei"),
        **tx
    }
    return tx_data

# Create your views here.
def homePage(request):
    """
    A functional based view for the home page
    """

    return render(request, "index.html")

# Create your views here.
def contact(request):
    """
    A functional based view for the contact page
    """

    return render(request, "contact.html")

# Create your views here.
def about(request):
    """
    A functional based view for the about page
    """

    return render(request, "about.html")

# Create your views here.
def properties(request):
    """
    A functional based view for the properties page
    """
      # Get the total number of tokens minted (this can be fetched from the contract)
    total_tokens = contract.functions.nextTokenId().call()

        # List to store asset details
    assets = []

    for token_id in range(total_tokens):
        # Fetch the price of the asset
        price = contract.functions.assetPrices(token_id).call()
        if price > 0:  # Only show assets that have a price set (i.e., for sale)
            # Fetch the token URI (metadata)
            token_uri = contract.functions.tokenURI(token_id).call()
                
            # Fetch the metadata from the token URI
            response = requests.get(token_uri)
            if response.status_code == 200:
                metadata = response.json()

                # Extract the image URL (assuming it's stored under 'image' field)
                image_url = metadata.get('image', None)

                # Append the asset details to the assets list
                assets.append({
                    'token_id': token_id,
                    'price': price,
                    'token_uri': token_uri,
                    'image_url': image_url  # Add image URL to asset
                })
               

     
    return render(request, "properties.html", {"list":assets})

def propertyView(request, _image_url, price):
    """
    A functional based view for the property view page
    """
    
    asset = {
        "picture": _image_url,
        "price": price
    }
    return render(request, "propertyView.html", {"asset":asset})
 #------------------------------YOU STOPPED HERE----------------------------------#