import os
import time
import web3
from typing import Any, Callable, Tuple
from hexbytes import HexBytes
from eth_account.signers.local import LocalAccount
from web3.contract import Contract
from logging import getLogger

from src.contract_abi import abi

logger= getLogger("Adoption Interface")

CONTRACT_ADDRESS= "0x876774b41083ed93499471062985a9581885834C"
PROJECT_ID= "2e278e77b1f140f08e5be5b79a6face2"

# We don't store inline both private key and secret project key
BASE_INFURA_URL= f"https://:{os.getenv('INFURA_PRIVATE_KEY_PROJECT')}@ropsten.infura.io/v3/"
if os.getenv("PRIVATE_KEY_DEV_META") is None:
    msg = "Environment variable is missing : PRIVATE_KEY_DEV_META"
    logger.error(msg)
    raise RuntimeError(msg)


w3= web3.Web3(web3.HTTPProvider(BASE_INFURA_URL+PROJECT_ID))
contract= w3.eth.contract(address= CONTRACT_ADDRESS,
                          abi= abi)

account = w3.eth.account.privateKeyToAccount(os.getenv("PRIVATE_KEY_DEV_META"))


def get_func_method(contract, method) -> Tuple[Callable, bool]:
    func_characteristics = [f for f in contract.functions._functions if f["name"] == method]
    if not func_characteristics:
        msg = ""
        raise RuntimeError(msg)

    need_args = func_characteristics[0]["inputs"] != []
    func = getattr(contract.functions, method)

    return func, need_args


def call_method(contract: Contract, method: str, *args, **kwargs) -> Any:
    func, need_args= get_func_method(contract, method)

    if need_args:
        func= func(*args, **kwargs)
    else:
        func= func()

    return func.call()


def transaction_method(contract: Contract,
                       account: LocalAccount,
                       method: str,
                       gas_multiplier: int = 1,
                       gas: int= 3000000,
                       *args, **kwargs) -> HexBytes:
    func, need_args= get_func_method(contract, method)
    if need_args:
        func= func(*args, **kwargs)
    else:
        func= func()

    nonce = w3.eth.get_transaction_count(account.address)
    contract_txn = func.buildTransaction({
        'gas': gas,
        'gasPrice': w3.eth.gas_price * gas_multiplier,
        "nonce": nonce
    })
    signed_txn = w3.eth.account.sign_transaction(contract_txn, private_key=account.privateKey)

    return w3.eth.send_raw_transaction(signed_txn.rawTransaction)

transaction_method(contract, account, "adoptAnimal", **{"_petId": 0})

if __name__ == "__main__":
    pass