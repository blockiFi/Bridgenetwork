pragma solidity ^0.8.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract chainBridge is Context{
   
     struct nativeAsset {
        address tokenAddress; 
        uint256 minAmount;
        uint256 transferFee;
        uint256 collectedFees; 
        uint256 balance; 
        uint256[] SupportedchainIds;
        mapping(uint256 => bool) isSupportedChain;
     }
    

    mapping(address => nativeAsset) public nativeAssets;
    mapping(address => bool) public isActiveNativeAsset;
    uint256 public chainId; // current chain id
    
   mapping(address => uint256) public getUserNonce; // submissionId (i.e. hash( debridgeId, amount, receiver, nonce)) => whether is claimed
   
   
   struct sendTransaction{
       uint256 chainIdTo;
       address assetAddress;
       uint256 amount;
       address receiver;
       bool  isCompleted;
   }
   bytes32[] public sendTransactionIDs;
   mapping (bytes32 => sendTransaction)  public sendTransactions;
    
   constructor () {
       nativeAsset storage asset = nativeAssets[address(0)];
       asset.tokenAddress = address(0); 
        asset.transferFee = 2;
        asset.SupportedchainIds.push(213);
        asset.isSupportedChain[213] = true;
        isActiveNativeAsset[address(0)] = true;
   }
   function send(uint256 chainTo ,  address assetAddress , uint256 amount ,  address receiver ) public payable {
       require(isActiveNativeAsset[assetAddress] , "Asset is Active");
       require(nativeAssets[assetAddress].isSupportedChain[chainTo] , "Chain not supported for this asset");
       require(amount  >= nativeAssets[assetAddress].minAmount , "amount below minimum");
       require(receiver != address(0) , "xant send to Zero address");
       require(processedPayment(assetAddress , amount) , "insuficient balance");
       
       uint256 sendAmount = deductFees(assetAddress , amount);
       uint256 nounce = getUserNonce[receiver];
       bytes32 transactionID =  keccak256(
                                        abi.encodePacked(chainTo, assetAddress , sendAmount, receiver, nounce)
                                    );
      sendTransactions[transactionID] = sendTransaction(chainTo , assetAddress ,sendAmount , receiver , false);
      nativeAssets[assetAddress].balance += sendAmount;
      sendTransactionIDs.push(transactionID);
       getUserNonce[receiver]++;
    //   emit sendsendAmount
   }
    // internal fxn used to process incoming payments 
    function processedPayment(address assetAddress , uint256 amount ) internal returns (bool) {
        
        if(assetAddress == address(0)){
            if(msg.value >= amount){
                return true;
            }else{
               return false; 
            }
        }else{
            IERC20 asset = IERC20(assetAddress);
            if(asset.allowance(_msgSender(), address(this)) >= amount ){
               asset.transferFrom(_msgSender() , address(this) , amount);
               return true;
            }else{
                return false;
            }
        }
    }
    // internal fxn for deducting and remitting fees after a sale
    function deductFees(address assetAddress , uint256 amount) internal returns (uint256) {
        nativeAsset storage asset =  nativeAssets[assetAddress];
         if(asset.transferFee > 0){
          uint256 fees_to_deduct = amount *  asset.transferFee  / 1000;
          asset.collectedFees += fees_to_deduct;
        //   payoutUser(feeRemitanceAddress , currentSaleItem.acceptedPaymentMethod ,  fees_to_deduct);
          return amount - fees_to_deduct;
          
         }else {
             return amount;
         }
    }
   
   
   
   
}