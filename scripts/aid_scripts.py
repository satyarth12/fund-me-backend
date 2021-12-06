from brownie import accounts, network, config
from web3 import Web3


def get_account_interface_add():
    if network.show_active() == "development":
        account = accounts[0]
        # MOKCING the Interface Address
        price_feed_address =
        return account, price_feed_address

    account = accounts.add(config["wallets"]["from_key"])
    # FORKING the Interface Address
    price_feed_address = config["network"][network.show_active(
    )]['eth_usd_price_feed']
    return account, price_feed_address


# def deploy_mocks()
