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
   
   
   struct Transaction{
       uint256 chainId;
       address assetAddress;
       uint256 amount;
       address receiver;
       bool  isCompleted;
   }
  struct validation {
      uint256 validationCount;
      mapping(address => bool) hasValidated;
      mapping(address => bool) verdict;
      address[] validators;
      bool validated;
  }
   bytes32[] public pendingSendTransactionIDs;
   bytes32[] public pendingClaimTransactionIDs;
   mapping (bytes32 => bool)  public isSendTransaction;
   mapping (bytes32 => Transaction)  public sendTransactions;
   mapping (bytes32 => bool)  public isClaimTransaction;
   mapping (bytes32 => Transaction)  public claimTransactions;
   
   mapping(bytes32 => validation ) public transactionValidations;
   uint256 public minValidations;
   constructor () {
       nativeAsset storage asset = nativeAssets[address(0)];
       asset.tokenAddress = address(0); 
        asset.transferFee = 2;
        asset.SupportedchainIds.push(213);
        asset.isSupportedChain[213] = true;
        isActiveNativeAsset[address(0)] = true;
   }
   function getID( uint256 chainFrom , address assetAddress , uint256 amount,  address receiver , uint256 nounce)public pure returns(bytes32){
       return  keccak256(
                                        abi.encodePacked(chainFrom, assetAddress , amount, receiver, nounce)
                                    );
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
      isSendTransaction[transactionID] = true;                             
      sendTransactions[transactionID] = Transaction(chainTo , assetAddress ,sendAmount , receiver , false);
      nativeAssets[assetAddress].balance += sendAmount;
      pendingSendTransactionIDs.push(transactionID);
       getUserNonce[receiver]++;
    //   emit sendsendAmount
   }
   function registerClaimTransaction(bytes32 claimID , uint256 chainFrom , address assetAddress , uint256 amount,  address receiver , uint256 nounce) public{
        require(!isClaimTransaction[claimID] , "already added to claims");
        
        bytes32 requiredClaimID = keccak256(
                                        abi.encodePacked(chainFrom, assetAddress , amount, receiver, nounce)
                                    );
        require(claimID  == requiredClaimID , "error validation claim ID");
        claimTransactions[claimID] = Transaction(chainFrom , assetAddress, amount , receiver , false);
        isClaimTransaction[claimID] =  true;
        pendingClaimTransactionIDs.push(claimID);
        
        
   }
   function claim(bytes32 claimID) public {
       require(isClaimTransaction[claimID] , "invalid caim ID");
       require(!claimTransactions[claimID].isCompleted , "claimed already");
       require(transactionValidations[claimID].validationCount >= minValidations , "not yet validated");
       uint256 amount = deductFees(claimTransactions[claimID].assetAddress , claimTransactions[claimID].amount);
       payoutUser(payable(claimTransactions[claimID].receiver), claimTransactions[claimID].assetAddress , amount);
       transactionValidations[claimID].validated =  true;
       claimTransactions[claimID].isCompleted = true;
   } 
   function validateClaim(bytes32 claimID , bool verdict ) public {
       require(isClaimTransaction[claimID] , "invalid caim ID");
       require(!claimTransactions[claimID].isCompleted , "claimed already");
       require(!transactionValidations[claimID].hasValidated[_msgSender()], "already validated");
       if(verdict){
       transactionValidations[claimID].validationCount ++;  
       }
       transactionValidations[claimID].verdict[_msgSender()]  = verdict ;
       transactionValidations[claimID].hasValidated[_msgSender()] =true;
       transactionValidations[claimID].validators.push(msg.sender);
       
   }
   function payoutUser(address payable recipient , address _paymentMethod , uint256 amount) private{
        if(_paymentMethod == address(0)){
          recipient.transfer(amount);
        }else {
             IERC20 currentPaymentMethod = IERC20(_paymentMethod);
             currentPaymentMethod.transfer(recipient , amount);
        }
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