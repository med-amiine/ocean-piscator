#setup
import os
from ocean_lib.ocean.ocean import Ocean
config = {'network': os.getenv('NETWORK_URL')}
ocean = Ocean(config)

#create an ERC20 object
print(f"Address of OCEAN token: {ocean.OCEAN_address}")
from ocean_lib.models.btoken import BToken #BToken is ERC20
OCEAN_token = BToken(ocean.OCEAN_address)

#set wallet
private_key = os.getenv('MY_TEST_KEY')
from ocean_lib.web3_internal.wallet import Wallet
wallet = Wallet(ocean.web3, private_key=private_key)
print(f"Address of your account: {wallet.address}")

#get balance
OCEAN_balance_base18 = OCEAN_token.balanceOf(wallet.address) #like wei
from ocean_lib.ocean import util
OCEAN_balance = util.from_base_18(OCEAN_balance_base18) #like eth
print(f"Balance: {OCEAN_balance} OCEAN")
if OCEAN_balance == 0.0:
  print("WARNING: you don't have any OCEAN yet")
