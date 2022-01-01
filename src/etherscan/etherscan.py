import enum
import json
import time
import requests
from dotenv import dotenv_values

API_KEY= dotenv_values("./../../.env")["ETHERSCAN_API_KEY"]


class NetworkEnum(enum.Enum):
    mainnet= ""
    ropsten= "-ropsten"
    goerli= "-goerli"
    kovan= "-kovan"
    rinkeby= "-rinkeby"


def generate_etherscan_url(network: NetworkEnum) -> str:
    try:
        network_value: str= network.value
    except AttributeError:
        raise AttributeError("Plesase select a value from NetworkEnum"
                   " (example NetworkEnum.mainet).")

    return f"https://api{network_value}.etherscan.io/api"


def get_etherscan_response(network: NetworkEnum, params: dict):
    base_url = generate_etherscan_url(network)
    response = requests.get(
        base_url,
        params= params,
        headers=requests.utils.default_headers()
    )

    # TODO : set HTTP error, not Exception (mais j'ai la flemme pour le moment)
    if response.status_code != 200:
        raise Exception(response.text)

    return json.loads(response.text)


def get_contract_abi(network: NetworkEnum, address: str):
    params= {
            "module": "contract",
            "action": "getabi",
            "address": address,
            "tag": "latest",
            "apikey": API_KEY,
        }
    return get_etherscan_response(network, params)


def get_last_block(network: NetworkEnum):
    params= {
            "module": "block",
            "action": "getblocknobytime",
            "timestamp": round(time.time()) + 1,
            "closest": "before",
            "apikey": API_KEY,
        }
    return get_etherscan_response(network, params)


get_contract_abi(NetworkEnum.mainnet, "0xB3de37059C441eBC4B6DFFB903Af5FB5b94e2dCe")
pass