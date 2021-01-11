#setup
import os
from ocean_lib.ocean.ocean import Ocean
from ocean_lib.web3_internal.wallet import Wallet
#from ocean_lib.ocean.ocean import Ocean


private_key = os.getenv('MY_TEST_KEY')
config = {'network': os.getenv('NETWORK_URL')}
ocean = Ocean(config)

print("create wallet: begin")
wallet = Wallet(ocean.web3, private_key=private_key)
print(f"create wallet: done. Its address is {wallet.address}")


print("create datatoken: begin. This will take a few seconds, since it's a transaction on Rinkeby.")
datatoken = ocean.create_data_token("Dataset name", "dtsymbol", from_wallet=wallet) 
print(f"created datatoken: done. Its address is {datatoken.address}")

