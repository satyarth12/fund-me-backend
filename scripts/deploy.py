from brownie import FundMe
from scripts.aid_scripts import get_account


def deply_fund_me():
    account = get_account()
    contract = FundMe.deploy({
        "from": account
    })
    print(contract.address)


def main():
    deply_fund_me()
