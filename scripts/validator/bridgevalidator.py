# import the following dependencies
import json
import os
from dotenv import load_dotenv
from eth_account import Account
from web3.auto import Web3
import asyncio

load_dotenv()

PRIVATE_KEY = os.get('PRIVATE_KEY')

NETWORKS_DETAILS = [
    {
        'name': 'kovan',
        'url': "https://kovan.infura.io/v3/d2ae878adfc8418fb4f4d73eefa31332",
        'bridgeAddress': "",
        'id': "97",
        'provider' : None,
        'contract' : None
    },
    {
        'name':'bsc',
        'url':'https://data-seed-prebsc-1-s1.binance.org:8545',
        'bridgeAddress': '',
        'id':'',
        'provider':None,
        'contract' : None
    }
]

BRIDGE_ABI = json.loads('[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,'
                        '"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},'
                        '{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],'
                        '"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,'
                        '"internalType":"bytes32","name":"transactionID","type":"bytes32"},{"indexed":false,'
                        '"internalType":"uint256","name":"chainID","type":"uint256"},{"indexed":true,'
                        '"internalType":"address","name":"assetAddress","type":"address"},{"indexed":false,'
                        '"internalType":"uint256","name":"sendAmount","type":"uint256"},{"indexed":true,'
                        '"internalType":"address","name":"receiver","type":"address"},{"indexed":false,'
                        '"internalType":"uint256","name":"nounce","type":"uint256"}],"name":"burnTransaction",'
                        '"type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"bytes32",'
                        '"name":"transactionID","type":"bytes32"},{"indexed":false,"internalType":"uint256",'
                        '"name":"chainID","type":"uint256"},{"indexed":true,"internalType":"address",'
                        '"name":"assetAddress","type":"address"},{"indexed":false,"internalType":"uint256",'
                        '"name":"sendAmount","type":"uint256"},{"indexed":true,"internalType":"address",'
                        '"name":"receiver","type":"address"},{"indexed":false,"internalType":"uint256",'
                        '"name":"nounce","type":"uint256"}],"name":"sendTransaction","type":"event"},{"inputs":[{'
                        '"internalType":"address","name":"assetAddress","type":"address"},{"internalType":"bool",'
                        '"name":"activate","type":"bool"}],"name":"activeNativeAsset","outputs":[],'
                        '"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address",'
                        '"name":"admin","type":"address"},{"internalType":"bool","name":"add","type":"bool"}],'
                        '"name":"addAdmin","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":['
                        '{"internalType":"address","name":"foriegnAddress","type":"address"},'
                        '{"internalType":"uint256","name":"chainID","type":"uint256"},{"internalType":"uint256",'
                        '"name":"minAmount","type":"uint256"},{"internalType":"string","name":"_name",'
                        '"type":"string"},{"internalType":"string","name":"_symbol","type":"string"}],'
                        '"name":"addForiegnAsset","outputs":[],"stateMutability":"nonpayable","type":"function"},'
                        '{"inputs":[{"internalType":"address","name":"assetAddress","type":"address"},'
                        '{"internalType":"uint256","name":"minAmount","type":"uint256"},{"internalType":"uint256[]",'
                        '"name":"supportedChains","type":"uint256[]"},{"internalType":"uint256","name":"transferFee",'
                        '"type":"uint256"}],"name":"addNativeAsset","outputs":[],"stateMutability":"nonpayable",'
                        '"type":"function"},{"inputs":[{"internalType":"address","name":"_oracle","type":"address"},'
                        '{"internalType":"bool","name":"add","type":"bool"}],"name":"addOracle","outputs":[],'
                        '"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address",'
                        '"name":"validator","type":"address"},{"internalType":"bool","name":"add","type":"bool"}],'
                        '"name":"addValidator","outputs":[],"stateMutability":"nonpayable","type":"function"},'
                        '{"inputs":[{"internalType":"address","name":"assetAddress","type":"address"},'
                        '{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"address",'
                        '"name":"receiver","type":"address"}],"name":"burn","outputs":[{"internalType":"bytes32",'
                        '"name":"","type":"bytes32"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{'
                        '"internalType":"bytes32","name":"","type":"bytes32"}],"name":"burnTransactions","outputs":[{'
                        '"internalType":"uint256","name":"chainId","type":"uint256"},{"internalType":"address",'
                        '"name":"assetAddress","type":"address"},{"internalType":"uint256","name":"amount",'
                        '"type":"uint256"},{"internalType":"address","name":"receiver","type":"address"},'
                        '{"internalType":"bool","name":"isCompleted","type":"bool"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[],"name":"chainId","outputs":[{"internalType":"uint256",'
                        '"name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                        '"internalType":"bytes32","name":"claimID","type":"bytes32"}],"name":"claim","outputs":[],'
                        '"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32",'
                        '"name":"","type":"bytes32"}],"name":"claimTransactions","outputs":[{'
                        '"internalType":"uint256","name":"chainId","type":"uint256"},{"internalType":"address",'
                        '"name":"assetAddress","type":"address"},{"internalType":"uint256","name":"amount",'
                        '"type":"uint256"},{"internalType":"address","name":"receiver","type":"address"},'
                        '{"internalType":"bool","name":"isCompleted","type":"bool"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[{"internalType":"address","name":"assetAddress",'
                        '"type":"address"}],"name":"foriegnAssetChain","outputs":[{"internalType":"uint256",'
                        '"name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                        '"internalType":"address","name":"","type":"address"}],"name":"foriegnAssets","outputs":[{'
                        '"internalType":"address","name":"nativeAddress","type":"address"},{"internalType":"address",'
                        '"name":"foriegnAddress","type":"address"},{"internalType":"uint256","name":"minAmount",'
                        '"type":"uint256"},{"internalType":"uint256","name":"chainID","type":"uint256"},'
                        '{"internalType":"bool","name":"isSet","type":"bool"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],'
                        '"name":"foriegnAssetsList","outputs":[{"internalType":"address","name":"",'
                        '"type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                        '"internalType":"uint256","name":"chainFrom","type":"uint256"},{"internalType":"address",'
                        '"name":"assetAddress","type":"address"},{"internalType":"uint256","name":"amount",'
                        '"type":"uint256"},{"internalType":"address","name":"receiver","type":"address"},'
                        '{"internalType":"uint256","name":"nounce","type":"uint256"}],"name":"getID","outputs":[{'
                        '"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"pure",'
                        '"type":"function"},{"inputs":[],"name":"getPendingClaimTransaction","outputs":[{'
                        '"internalType":"bytes32[]","name":"","type":"bytes32[]"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[],"name":"getPendingMintTransaction","outputs":[{'
                        '"internalType":"bytes32[]","name":"","type":"bytes32[]"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[{"internalType":"address","name":"assetAddress",'
                        '"type":"address"}],"name":"getSupportedchainIds","outputs":[{"internalType":"uint256[]",'
                        '"name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                        '"internalType":"address","name":"","type":"address"}],"name":"getUserNonce","outputs":[{'
                        '"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[],"name":"getforiegnAssetsList","outputs":[{'
                        '"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[],"name":"getnativeAssetsList","outputs":[{'
                        '"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],'
                        '"name":"hasWrappedForiegnPair","outputs":[{"internalType":"bool","name":"","type":"bool"}],'
                        '"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"",'
                        '"type":"address"}],"name":"isActiveNativeAsset","outputs":[{"internalType":"bool","name":"",'
                        '"type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                        '"internalType":"address","name":"","type":"address"}],"name":"isAdmin","outputs":[{'
                        '"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},'
                        '{"inputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],'
                        '"name":"isClaimTransaction","outputs":[{"internalType":"bool","name":"","type":"bool"}],'
                        '"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"",'
                        '"type":"bytes32"}],"name":"isMintTransactions","outputs":[{"internalType":"bool","name":"",'
                        '"type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                        '"internalType":"address","name":"","type":"address"}],"name":"isOracle","outputs":[{'
                        '"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},'
                        '{"inputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],'
                        '"name":"isSendTransaction","outputs":[{"internalType":"bool","name":"","type":"bool"}],'
                        '"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"",'
                        '"type":"address"}],"name":"isValidator","outputs":[{"internalType":"bool","name":"",'
                        '"type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                        '"internalType":"bytes32","name":"","type":"bytes32"}],"name":"isburnTransactions",'
                        '"outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[],"name":"minValidations","outputs":[{'
                        '"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[{"internalType":"bytes32","name":"mintID","type":"bytes32"}],'
                        '"name":"mint","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{'
                        '"internalType":"bytes32","name":"","type":"bytes32"}],"name":"mintTransactions","outputs":[{'
                        '"internalType":"uint256","name":"chainId","type":"uint256"},{"internalType":"address",'
                        '"name":"assetAddress","type":"address"},{"internalType":"uint256","name":"amount",'
                        '"type":"uint256"},{"internalType":"address","name":"receiver","type":"address"},'
                        '{"internalType":"bool","name":"isCompleted","type":"bool"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],'
                        '"name":"nativeAssets","outputs":[{"internalType":"address","name":"tokenAddress",'
                        '"type":"address"},{"internalType":"uint256","name":"minAmount","type":"uint256"},'
                        '{"internalType":"uint256","name":"transferFee","type":"uint256"},{"internalType":"uint256",'
                        '"name":"collectedFees","type":"uint256"},{"internalType":"uint256","name":"balance",'
                        '"type":"uint256"},{"internalType":"bool","name":"isSet","type":"bool"}],'
                        '"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"",'
                        '"type":"uint256"}],"name":"nativeAssetsList","outputs":[{"internalType":"address","name":"",'
                        '"type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner",'
                        '"outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],'
                        '"name":"pendingBurnTransactions","outputs":[{"internalType":"bytes32","name":"",'
                        '"type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                        '"internalType":"uint256","name":"","type":"uint256"}],"name":"pendingClaimTransactionIDs",'
                        '"outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],'
                        '"name":"pendingMintTransactions","outputs":[{"internalType":"bytes32","name":"",'
                        '"type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                        '"internalType":"uint256","name":"","type":"uint256"}],"name":"pendingSendTransactionIDs",'
                        '"outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[{"internalType":"bytes32","name":"claimID","type":"bytes32"},'
                        '{"internalType":"uint256","name":"chainFrom","type":"uint256"},{"internalType":"address",'
                        '"name":"assetAddress","type":"address"},{"internalType":"uint256","name":"amount",'
                        '"type":"uint256"},{"internalType":"address","name":"receiver","type":"address"},'
                        '{"internalType":"uint256","name":"nounce","type":"uint256"}],'
                        '"name":"registerClaimTransaction","outputs":[],"stateMutability":"nonpayable",'
                        '"type":"function"},{"inputs":[{"internalType":"bytes32","name":"mintID","type":"bytes32"},'
                        '{"internalType":"uint256","name":"chainFrom","type":"uint256"},{"internalType":"address",'
                        '"name":"assetAddress","type":"address"},{"internalType":"uint256","name":"amount",'
                        '"type":"uint256"},{"internalType":"address","name":"receiver","type":"address"},'
                        '{"internalType":"uint256","name":"nounce","type":"uint256"}],'
                        '"name":"registerMintTransaction","outputs":[],"stateMutability":"nonpayable",'
                        '"type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],'
                        '"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256",'
                        '"name":"chainTo","type":"uint256"},{"internalType":"address","name":"assetAddress",'
                        '"type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"},'
                        '{"internalType":"address","name":"receiver","type":"address"}],"name":"send","outputs":[{'
                        '"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"payable",'
                        '"type":"function"},{"inputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],'
                        '"name":"sendTransactions","outputs":[{"internalType":"uint256","name":"chainId",'
                        '"type":"uint256"},{"internalType":"address","name":"assetAddress","type":"address"},'
                        '{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"address",'
                        '"name":"receiver","type":"address"},{"internalType":"bool","name":"isCompleted",'
                        '"type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{'
                        '"internalType":"bytes32","name":"","type":"bytes32"}],"name":"transactionValidations",'
                        '"outputs":[{"internalType":"uint256","name":"validationCount","type":"uint256"},'
                        '{"internalType":"bool","name":"validated","type":"bool"}],"stateMutability":"view",'
                        '"type":"function"},{"inputs":[{"internalType":"address","name":"newOwner",'
                        '"type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable",'
                        '"type":"function"},{"inputs":[{"internalType":"bytes32","name":"claimID","type":"bytes32"},'
                        '{"internalType":"bool","name":"verdict","type":"bool"}],"name":"validateClaim","outputs":[],'
                        '"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32",'
                        '"name":"mintID","type":"bytes32"},{"internalType":"bool","name":"verdict","type":"bool"}],'
                        '"name":"validateMint","outputs":[],"stateMutability":"nonpayable","type":"function"},'
                        '{"inputs":[{"internalType":"address","name":"","type":"address"}],'
                        '"name":"wrappedForiegnPair","outputs":[{"internalType":"address","name":"",'
                        '"type":"address"}],"stateMutability":"view","type":"function"}]')

def get_providers(networks_details):
    for i in range(len(networks_details)):
        network_url = networks_details[i]['url']
        networks_details[i]['provider'] = Web3(Web3.HTTPProvider(network_url))

def get_contracts(networks_details):
    for i in range(len(networks_details)):
        provider = networks_details[i]['provider']
        address = networks_details[i]['bridgeAddress']
        networks_details[i]['contract'] = provider.eth.contract(address=address, abi=BRIDGE_ABI)




ETH_ACCOUNT = Account.from_key(PRIVATE_KEY)


def handle_event(event, action):
    print(ETH_ACCOUNT.address)
    print(event.args.transactionID)
    print(event.args.assetAddress)
    # chainID
    # transactionID
    # sendAmount
    # receiver
    # nounce
    # (bytes32

    print(bsc.eth.get_balance(ETH_ACCOUNT.address))
    nonce = bsc.eth.getTransactionCount(ETH_ACCOUNT.address)
    if action == 'send':
        transaction = contract2.functions.registerMintTransaction(
            event.args.transactionID,
            42,
            event.args.assetAddress,
            event.args.sendAmount,
            event.args.receiver,
            event.args.nounce
        ).buildTransaction(
            {
                'nonce': nonce,
                'from': ETH_ACCOUNT.address
            }
        )
        signed_txn = bsc.eth.account.sign_transaction(transaction, private_key=private_key)
        tx_hash = bsc.eth.sendRawTransaction(signed_txn.rawTransaction)
        print(tx_hash)
    if action == 'burn':
        transaction = contract2.functions.registerClaimTransaction().call()
        signed_txn = bsc.eth.account.sign_transaction(transaction, private_key=private_key)
        tx_hash = bsc.eth.sendRawTransaction(signed_txn.rawTransaction)
        print(tx_hash)


def validateTransaction(sendTransaction, mintTransaction):
    return sendTransaction[2] == mintTransaction[2] and sendTransaction[3] == mintTransaction[3] and sendTransaction[4] == mintTransaction[4]
        


def main():
    get_providers()
    get_contracts()
    while True:

        for i in range(len(NETWORKS_DETAILS)):
            contract2  = NETWORKS_DETAILS[i]['contract']
            provider2 = NETWORKS_DETAILS[i]['provider']
            mintTransactions = contract2.functions.getPendingMintTransaction().call()
            for transaction in mintTransactions:
                for j in range(len(NETWORKS_DETAILS)):
                    contract1 = NETWORKS_DETAILS[j]['contract']
                    mintTransaction = contract2.functions.mintTransactions(transaction).call()
                    sendTransaction = contract1.functions.sendTransactions(transaction).call()
                    validation = validateTransaction(sendTransaction, mintTransaction)
                    try:
                        nonce = provider2.eth.getTransactionCount(ETH_ACCOUNT.address)
                        validationtransaction = contract2.functions.validateMint(transaction, validation).buildTransaction(
                            {
                                'nonce': nonce,
                                'from': ETH_ACCOUNT.address
                            }
                        )
                        signed_txn = provider2.eth.account.sign_transaction(validationtransaction, private_key=PRIVATE_KEY)
                        tx_hash = provider2.eth.sendRawTransaction(signed_txn.rawTransaction)
                        print(tx_hash)
                    except:
                        print("error")
            
            claimTransactions = contract2.functions.getPendingClaimTransaction().call()
            for transaction in claimTransactions:
                for j in range(len(NETWORKS_DETAILS)):
                    contract1 = NETWORKS_DETAILS[j]['contract']
                    claimTransaction = contract2.functions.claimTransactions(transaction).call()
                    burnTransaction = contract1.functions.burnTransactions(transaction).call()
                    validation = validateTransaction(claimTransaction, burnTransaction)
                    try:
                        nonce = provider2.eth.getTransactionCount(ETH_ACCOUNT.address)
                        validationtransaction = contract2.functions.validateMint(transaction, validation).buildTransaction(
                            {
                                'nonce': nonce,
                                'from': ETH_ACCOUNT.address
                            }
                        )
                        signed_txn = provider2.eth.account.sign_transaction(validationtransaction, private_key=PRIVATE_KEY)
                        tx_hash = provider2.eth.sendRawTransaction(signed_txn.rawTransaction)
                        print(tx_hash)
                    except:
                        print("error")


if __name__ == "__main__":
    main()
