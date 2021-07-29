# import the following dependencies
import json
from eth_account import Account
from web3 import Web3
import asyncio

infura_url = 'https://kovan.infura.io/v3/d2ae878adfc8418fb4f4d73eefa31332'
ankr_url = 'https://data-seed-prebsc-1-s1.binance.org:8545'
networks = [
    {
        'name': 'kovan',
        'url': "https://kovan.infura.io/v3/d2ae878adfc8418fb4f4d73eefa31332",
        'bridgeAddress': "",
        'id': "97"

    }
]
kovan = Web3(Web3.HTTPProvider(infura_url))
bsc = Web3(Web3.HTTPProvider(ankr_url))
# add your blockchain connection information
# uniswap address and abi
bridge1Address = '0x5e0139A1bdE4C3eD4Bcb53D04ab4CCe7bDBD1BA5'
bridge2Address = '0x7Ee9BD6566b9A5C068a7bfE4D1568411C80B36d4'
bridge_abi = json.loads('[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,'
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

contract1 = kovan.eth.contract(address=bridge1Address, abi=bridge_abi)
contract2 = bsc.eth.contract(address=bridge2Address, abi=bridge_abi)
private_key = "ceca046e9dbf795a85cce82174317ed6007ae0686ff84f730888f285278e3b68"
acct = Account.from_key(private_key)


def handle_event(event, action):
    print(acct.address)
    print(event.args.transactionID)
    print(event.args.assetAddress)
    # chainID
    # transactionID
    # sendAmount
    # receiver
    # nounce
    # (bytes32

    print(bsc.eth.get_balance(acct.address))
    nonce = bsc.eth.getTransactionCount(acct.address)
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
                'from': acct.address
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
    if (
            sendTransaction[2] == mintTransaction[2] and
            sendTransaction[3] == mintTransaction[3] and
            sendTransaction[4] == mintTransaction[4]):
        return True
    else:
        return False


def main():
    while True:

        mintTransactions = contract2.functions.getPendingMintTransaction().call()
        print(mintTransactions)
        if len(mintTransactions) == 0:
            print("no mint transaction")
        else:
            for transaction in mintTransactions:
                print(transaction)

                mintTransaction = contract2.functions.mintTransactions(transaction).call()
                print(mintTransaction)
                sendTransaction = contract1.functions.sendTransactions(transaction).call()
                print(sendTransaction)
                if validateTransaction(sendTransaction, mintTransaction):
                    validation = True
                else:
                    validation = False

                try:
                    nonce = bsc.eth.getTransactionCount(acct.address)
                    validationtransaction = contract2.functions.validateMint(transaction, validation).buildTransaction(
                        {
                            'nonce': nonce,
                            'from': acct.address
                        }
                    )
                    signed_txn = bsc.eth.account.sign_transaction(validationtransaction, private_key=private_key)
                    tx_hash = bsc.eth.sendRawTransaction(signed_txn.rawTransaction)
                    print(tx_hash)
                except:
                    print("eroor")

        claimTransactions = contract2.functions.getPendingClaimTransaction().call()
        if len(claimTransactions) == 0:
            print("no claim transaction")
        else:
            for transaction in claimTransactions:
                print(transaction)
                claimTransaction = contract2.functions.claimTransactions(transaction).call()
                print(claimTransaction)
                burnTransaction = contract1.functions.burnTransactions(transaction).call()
                print(burnTransaction)
                if validateTransaction(claimTransaction, burnTransaction):
                    validation = True
                else:
                    validation = False

                try:
                    nonce = bsc.eth.getTransactionCount(acct.address)
                    validationtransaction = contract2.functions.validateClaim(transaction, validation).buildTransaction(
                        {
                            'nonce': nonce,
                            'from': acct.address
                        }
                    )
                    signed_txn = bsc.eth.account.sign_transaction(validationtransaction, private_key=private_key)
                    tx_hash = bsc.eth.sendRawTransaction(signed_txn.rawTransaction)
                    print(tx_hash)
                except:
                    print("eroor")




if __name__ == "__main__":
    main()
