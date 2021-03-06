
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

// File: @openzeppelin/contracts/access/Ownable.sol

pragma solidity >=0.6.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor ()  {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}



pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
pragma solidity ^0.8.0;

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}
pragma solidity ^0.8.0;


/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

interface IWRAPPEDTOKEN {
    
     function burn(uint256 amount) external ;
     function mint(address account , uint256 amount) external ;
}
contract WRAPPEDTOKEN is ERC20 ,Ownable {
    constructor (string memory _name ,  string memory _symbol)  ERC20(_name , _symbol){
        
    } 
    function burn(uint256 amount) public   onlyOwner {
        _burn(_msgSender(), amount);
    }
    function mint(address account, uint256 amount) public  onlyOwner{
     _mint( account,  amount) ;   
    }
    
    
}
contract administration is Ownable {
    mapping(address =>bool) public isAdmin;
    modifier onlyAdmin() {
        require(isAdmin[_msgSender()] || _msgSender() == owner() , "unathourized access");
        _;
    }
    constructor() {
        
        
    }
    
    function addAdmin(address admin , bool add) public onlyOwner {
        isAdmin[admin] = add;
    }
}
contract validationable is administration{
  mapping(address =>bool) public isValidator;
    modifier onlyValidator() {
        require(isValidator[_msgSender()] , "unathourized access");
        _;
    }
    constructor() {
        
    }
    
    function addValidator(address validator , bool add) public onlyAdmin {
        isValidator[validator] = add;
    }  
}
contract oracle is administration{
  mapping(address =>bool) public isOracle;
    modifier onlyOracle() {
        require(isOracle[_msgSender()] , "unathourized access");
        _;
    }
    constructor() {
        
    }
    
    function addOracle(address _oracle , bool add) public onlyAdmin {
        isOracle[_oracle] = add;
    }  
}
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

contract chainBridge is Context , validationable , oracle {
   
     struct nativeAsset {
        address tokenAddress; 
        uint256 minAmount;
        uint256 transferFee;
        uint256 collectedFees; 
        uint256 balance; 
        uint256[] SupportedchainIds;
        mapping(uint256 => bool) isSupportedChain;
        bool isSet;
     }
    
    address[] public nativeAssetsList;
    mapping(address => nativeAsset) public nativeAssets;
    mapping(address => bool) public isActiveNativeAsset;
    uint256 public chainId = 42; // current chain id
    struct foriegnAsset {
       address nativeAddress; 
       address foriegnAddress;
        uint256 minAmount; 
        uint256 chainID;
        bool isSet ;
   }
   function getSupportedchainIds(address assetAddress ) public view returns(uint256[] memory){
       return nativeAssets[assetAddress].SupportedchainIds;
   }
   function foriegnAssetChain(address assetAddress) public  view returns(uint256){
      return foriegnAssets[assetAddress].chainID;
   }
   address[] public foriegnAssetsList;
   function getforiegnAssetsList() public view returns(address[] memory){
       return  foriegnAssetsList;
   }
    function getnativeAssetsList() public view returns(address[] memory){
       return  nativeAssetsList;
   }
   mapping(address => foriegnAsset) public foriegnAssets;
   mapping(address => address) public wrappedForiegnPair;
   mapping(address => bool) public hasWrappedForiegnPair;
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
   
    bytes32[] public pendingMintTransactions;
   mapping(bytes32 => Transaction) public mintTransactions;
   mapping(bytes32 => bool) public isMintTransactions;
   
   bytes32[] public pendingBurnTransactions;
   mapping(bytes32 => Transaction) public burnTransactions;
   mapping(bytes32 => bool) public isburnTransactions;
   mapping(bytes32 => validation ) public transactionValidations;
   uint256 public minValidations;
   event sendTransaction(bytes32 transactionID  , uint256 chainID ,address indexed assetAddress ,uint256 sendAmount ,address indexed receiver ,uint256 nounce );
   event burnTransaction(bytes32 transactionID  , uint256 chainID ,address indexed assetAddress ,uint256 sendAmount ,address indexed receiver ,uint256 nounce );
   constructor () {
       
   }
   function getID( uint256 chainFrom , address assetAddress , uint256 amount,  address receiver , uint256 nounce)public pure returns(bytes32){
       return  keccak256(
                                        abi.encodePacked(chainFrom, assetAddress , amount, receiver, nounce)
                                    );
   }
   function getPendingMintTransaction() public view returns(bytes32[] memory){
       return pendingMintTransactions;
   }
   function getPendingClaimTransaction() public  view returns(bytes32[] memory){
       return pendingClaimTransactionIDs;
   }
   function addNativeAsset(address assetAddress , uint256 minAmount , uint256[] memory supportedChains , uint256 transferFee) public onlyAdmin {
       require(!nativeAssets[assetAddress].isSet , "already added");
       nativeAsset storage newNativeAsset = nativeAssets[assetAddress];
       newNativeAsset.tokenAddress = assetAddress;
       newNativeAsset.minAmount = minAmount;
       newNativeAsset.transferFee = transferFee;
       newNativeAsset.isSet = true;
       isActiveNativeAsset[assetAddress] = true;
       nativeAssetsList.push(assetAddress);
       for(uint256 index; index < supportedChains.length ; index++){
           if(!nativeAssets[assetAddress].isSupportedChain[supportedChains[index]]){
             nativeAssets[assetAddress].isSupportedChain[supportedChains[index]] = true;
             nativeAssets[assetAddress].SupportedchainIds.push(supportedChains[index]);
           }
       }
       
    
   }
   function activeNativeAsset(address assetAddress ,bool activate) public onlyAdmin{
       isActiveNativeAsset[assetAddress] = activate;
   }
   function send(uint256 chainTo ,  address assetAddress , uint256 amount ,  address receiver ) public payable returns(bytes32){
       require(isActiveNativeAsset[assetAddress] , "Asset is not Active");
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
    emit sendTransaction(transactionID  ,chainTo , assetAddress , sendAmount , receiver , nounce );
    return transactionID;
   }
   function registerClaimTransaction(bytes32 claimID , uint256 chainFrom , address assetAddress , uint256 amount,  address receiver , uint256 nounce) public onlyOracle{
        require(!isClaimTransaction[claimID] , "cliam: already added to claims");
        require(nativeAssets[assetAddress].isSupportedChain[chainFrom] , "invalid chain from");
        bytes32 requiredClaimID = keccak256(
                                        abi.encodePacked(chainId, assetAddress , amount, receiver, nounce)
                                    );
        require(claimID  == requiredClaimID , "error validation claim ID");
        claimTransactions[claimID] = Transaction(chainId , assetAddress, amount , receiver , false);
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
        for(uint256 index; index <pendingClaimTransactionIDs.length ; index++){
           if(pendingClaimTransactionIDs[index] == claimID){
               pendingClaimTransactionIDs[index] = pendingClaimTransactionIDs[pendingClaimTransactionIDs.length - 1];
               pendingClaimTransactionIDs.pop();
               
           }
       }
   } 
   function validateClaim(bytes32 claimID , bool verdict ) public onlyValidator{
       require(isClaimTransaction[claimID] , "invalid caim ID");
       require(!claimTransactions[claimID].isCompleted , "claimed already");
       require(!transactionValidations[claimID].hasValidated[_msgSender()], "already validated");
       if(verdict){
       transactionValidations[claimID].validationCount ++;  
       }
       transactionValidations[claimID].verdict[_msgSender()]  = verdict ;
       transactionValidations[claimID].hasValidated[_msgSender()] =true;
       transactionValidations[claimID].validators.push(msg.sender);
       
       if(transactionValidations[claimID].validationCount >= minValidations){
         claim(claimID);
       }
   }
   function validateMint(bytes32 mintID , bool verdict ) public onlyValidator{
       require(isMintTransactions[mintID] , "invalid mint ID");
       require(!mintTransactions[mintID].isCompleted , "claimed already");
       require(!transactionValidations[mintID].hasValidated[_msgSender()], "already validated");
       if(verdict){
       transactionValidations[mintID].validationCount ++;  
       }
       transactionValidations[mintID].verdict[_msgSender()]  = verdict ;
       transactionValidations[mintID].hasValidated[_msgSender()] =true;
       transactionValidations[mintID].validators.push(msg.sender);
      
       if(transactionValidations[mintID].validationCount >= minValidations){
         mint(mintID);
       }
       
   }
   function addForiegnAsset(address foriegnAddress , uint256 chainID , uint256 minAmount ,string memory _name , string memory _symbol) public onlyAdmin{
       require(!foriegnAssets[foriegnAddress].isSet , "already registered");
       WRAPPEDTOKEN wrappedAddress = new WRAPPEDTOKEN(string(abi.encodePacked( "R", _name)) , string(abi.encodePacked("R" , _symbol)));
       foriegnAssets[foriegnAddress] = foriegnAsset(address(wrappedAddress), foriegnAddress , minAmount , chainID , true);
       wrappedForiegnPair[address(wrappedAddress)] =  foriegnAddress;
       hasWrappedForiegnPair[address(wrappedAddress)] = true;
       foriegnAssetsList.push(address(wrappedAddress));
   }
   function registerMintTransaction(bytes32 mintID , uint256 chainFrom , address assetAddress , uint256 amount,  address receiver , uint256 nounce) public onlyOracle{
       require(foriegnAssets[assetAddress].isSet , "mint: not a registerred foriegn asset");
       require(foriegnAssets[assetAddress].chainID == chainFrom , "mint: request from wrong chain");
       bytes32 requiredmintID = keccak256(
                                        abi.encodePacked(chainId, assetAddress , amount, receiver, nounce)
                                    );
        require(mintID  == requiredmintID, "mint: error validation mint ID");
        mintTransactions[mintID]  = Transaction(chainFrom , foriegnAssets[assetAddress].nativeAddress, amount , receiver , false);
        isMintTransactions[mintID] = true;
        pendingMintTransactions.push(mintID);
       
   }
   function burn( address assetAddress , uint256 amount ,  address receiver) public  returns(bytes32){
        require(hasWrappedForiegnPair[assetAddress] , "has no foriegnAsset pair ");
       require(amount  >= foriegnAssets[wrappedForiegnPair[assetAddress]].minAmount , "amount below minimum");
       require(receiver != address(0) , "xant send to Zero address");
       require(processedPayment(assetAddress , amount) , "insuficient balance");
      uint256 chainTo =foriegnAssets[wrappedForiegnPair[assetAddress]].chainID;
      address _foriegnAsset = wrappedForiegnPair[assetAddress];
       uint256 nounce = getUserNonce[receiver];
       bytes32 burnID =  keccak256(
                                        abi.encodePacked( chainTo, _foriegnAsset , amount, receiver, nounce)
                                    );
      isburnTransactions[burnID] = true;                             
      burnTransactions[burnID] = Transaction(chainTo , assetAddress ,amount , receiver , false);
      
      pendingBurnTransactions.push(burnID);
       getUserNonce[receiver]++;
       emit burnTransaction(burnID  ,chainTo , _foriegnAsset , amount , receiver , nounce );
       return burnID;
   }
   function _burnToken(  address token , uint256 amount) private{
       WRAPPEDTOKEN wrappedToken = WRAPPEDTOKEN(token);
       wrappedToken.burn( amount);
   }
   function mint(bytes32 mintID) public {
      require(isMintTransactions[mintID], "not a valid mint ID");
      require(!mintTransactions[mintID].isCompleted ,"already minted" );
      require(transactionValidations[mintID].validationCount >= minValidations , "not yet validated");
      
       _mintToken(mintTransactions[mintID].receiver, mintTransactions[mintID].assetAddress , mintTransactions[mintID].amount);
       transactionValidations[mintID].validated =  true;
       mintTransactions[mintID].isCompleted = true;
       for(uint256 index; index <pendingMintTransactions.length ; index++){
           if(pendingMintTransactions[index] == mintID){
               pendingMintTransactions[index] = pendingMintTransactions[pendingMintTransactions.length - 1];
               pendingMintTransactions.pop();
               
           }
       }
   }
   function _mintToken(address receiver,  address token , uint256 amount) private{
       WRAPPEDTOKEN wrappedToken = WRAPPEDTOKEN(token);
       wrappedToken.mint(receiver , amount);
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