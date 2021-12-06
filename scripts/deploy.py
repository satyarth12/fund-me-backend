from brownie import FundMe
from scripts.aid_scripts import get_account_interface_add


def deply_fund_me():
    account, interface_address = get_account_interface_add()

    # Pass the interface address to the FundMe contract
    contract = FundMe.deploy(
        "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e",
        {
            "from": account
        },
        publish_source=True)
    print(contract.address)


def main():
    deply_fund_me()
