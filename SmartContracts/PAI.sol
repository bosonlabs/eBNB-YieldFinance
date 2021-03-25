/**
// PAI is a Deflationary token with a 4% redistribution tax & 4% Deflation and 2% of token added to reserved wallet
*/

// SPDX-License-Identifier: MIT


/*
 *  This contract is  Redesigned to maximize profit.
 *  PAI works by applying 5% the fee which is 4% to each transaction 
    & instantly splitting that fee among all holders of the token & 4% is automatically burn that continuously 
    reduces the total supply of PAI (PAI)and 2 % token reserved in treasury wallet address .
 */
 

pragma solidity ^0.6.0;


abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}



/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IBEP20 {
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
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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



/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) public returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

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
contract Ownable is Context {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
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
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}
/*created by:
Prabhakaran (@Prabhakaran1998)
Martina Gracy(@Martinagracy28)
Role:solidity Developer-boson labs
date:23-FEB-2020
reviewed by:hemadri -project director-Boson Labs */
contract PAI is Context, IBEP20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) public _rOwned;
    mapping (address => uint256) public _tOwned;
    mapping (address => mapping (address => uint256)) public _allowances;

    mapping (address => bool) public _isrewardExcluded;
    address[] public _rewardExcluded;
   
    uint256 private constant MAX = ~uint256(0);
   // uint256 private _tTotal = 1000000 * 10**6 * 10**7; 
    //uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tTaxTotal;
    uint256 private _tBurnTotal;
/*
     Initialize Token name,Symbol and TotalSupply.
     Token name ="PAI Token";
     Token Symbol = "PAI";
     Total Supply ="10000000000";
     
 */
    string private _name ;
    string private _symbol;
    uint8 private _decimals;
   	/*
	 * PAI works by applying 10% transaction fee in which 4% is send  instantly to all token holders.
	 * and 4% is automatically burnt which continuously reduces the total supply of PAI (PAI).
     * and 2% is added in reserved wallet address.
	 *_taxFee parameter is used to initialize transaction fee 4%.
     *_burnFee parameter is used to initialize  Burn fee  4%.
	 * _maxTxAmount Parameter is used to initialize maxTransferAmount.
	 * treasuryamount parameter is used for reserveamount 
	 * treasuryaddress parameter initialize address of treasury wallet which contain treasury amount
	 */
    uint256 private _taxFee;
    uint256 private _burnFee;
    uint256 private _maxTxAmount;
    address public treasuryaddress;
    uint256 public treasuryhundres;

     function initialize(address owner) public  initializer
{
    _owner = owner;
    _name = 'Testing Token';
    _symbol = 'Testing';
    _decimals = 9;
    //for phase1 testing total supply initialized as 1000000
     _tTotal = 100 * 10**6 * 10**7; 
    //_tTotal = 1000000 * 10**6 * 10**7; 
    _taxFee = 4;
    _burnFee = 4;
    _maxTxAmount =2500000e9 ;
    treasuryhundres = 100;
    treasuryaddress = address(0x0Ef04FFA95f2eC2D07a5a196b4cEFB9d1076D43c);
    _rTotal = (MAX - (MAX % _tTotal));
    _rOwned[_msgSender()] = _rTotal;
     emit Transfer(address(0), _msgSender(), _tTotal);
    }
	/**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }
 /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }
/**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {BEP20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IBEP20-balanceOf} and {IBEP20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
 /**
     * @dev Returns the totalSupply of the token.
     */
    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }
   /**
     * account who The address to query.
     * The balance of the specified address.
     */
    function balanceOf(address account) public view override returns (uint256) {
        if (_isrewardExcluded[account]){
        if(account == treasuryaddress)return _rOwned[account];
         return _tOwned[account];
        }
        if(account == treasuryaddress)  return _rOwned[account];
        return tokenFromPai(_rOwned[account]);
    }
/**
     *  Transfer tokens to a specified address.
     *  The address to transfer .
     *  The amount to be transferred.
     *  True on success, false otherwise.
     */ 
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
/**
     *  Function to check the amount of tokens that an owner has allowed to a spender to Spend.
     *  The owner address which owns the funds.
     *  The spender address which will spend the funds.
     *  Returns the number of tokens still available for the spender.
     */
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }
	 /**
     * Approve the spender address to spend the specified amount of tokens on behalf of
     * _msgSender(). This method is included for BEP20 compatibility.
     * spender address which will spend the funds.
     * value amount of tokens to be spent.
     */
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    
 /**
     * Transfer tokens from one address to another.
     * sender address you want to send tokens from.
     * recipient address you want to transfer to.
     * value The amount of tokens to be transferred.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
        return true;
    }
 /**
     * Increase the amount of tokens that an owner has allowed to a spender.
     * spender address which will spend the funds.
     * addedValue amount of tokens to increase the allowance by.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
 /**
     *  Decrease the amount of tokens that an owner has allowed to a spender.
     *  spender address which will spend the funds.
     *  subtractedValue amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
        return true;
    }
/**
     * @dev Returns true if account address is added as rewardExcluded 
	 * rewardExcluded address which does not receive any reward instantly when Holders buy token.
     */
    function isrewardExcluded(address account) public view returns (bool) {
        return _isrewardExcluded[account];
    }
   
/**
     * @dev Returns the totalTax of the token.
     */
    function totalTax() public view returns (uint256) {
        return _tTaxTotal;
    }
    /**
     * @dev Returns the totalBurn of the token.
     */
    function totalBurn() public view returns (uint256) {
        return _tBurnTotal;
    }
 /**
     * @dev   paifi() function adds transfer amount tAmount to _tTaxTotal
	      
		  */
    function paifi(uint256 tAmount) public {
        address sender = _msgSender();
        require(!_isrewardExcluded[sender], "rewardExcluded addresses cannot call this function");
        (uint256 rAmount,,,,,) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rTotal = _rTotal.sub(rAmount);
        _tTaxTotal = _tTaxTotal.add(tAmount);
    }

    function paiFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount,,,,,) = _getValues(tAmount);
            return rAmount;
        } else {
            (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
            return rTransferAmount;
        }
    }

    function tokenFromPai(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total Tester3");
        uint256 currentRate =  _getRate();
        return rAmount.div(currentRate);
    }

    function rewardexcludeAccount(address account) external onlyOwner() {
        require(account != 0xD3ce6898eC2252713F96FC21921cEBfca27501d2, 'We can not exclude Uniswap router.');
        require(!_isrewardExcluded[account], "Account is already rewardExcluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] =tokenFromPai(_rOwned[account]);
        }
        _isrewardExcluded[account] = true;
        _rewardExcluded.push(account);
    }

    function rewardincludeAccount(address account) external onlyOwner() {
        require(_isrewardExcluded[account], "Account is already rewardExcluded");
        for (uint256 i = 0; i < _rewardExcluded.length; i++) {
            if (_rewardExcluded[i] == account) {
                _rewardExcluded[i] = _rewardExcluded[_rewardExcluded.length - 1];
                _tOwned[account] = 0;
                _isrewardExcluded[account] = false;
                _rewardExcluded.pop();
                break;
            }
        }
    }

    function _approve(address owner, address spender, uint256 amount) public {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
	
	/**
     *  Transfer PAI tokens to a specified address.
     *  The address sender ,recipient to transfer .
     *  The amount to be transferred.
     *  billion parameter used for initialize 1billion
     *  hundredmillion parameter used for initialize 100million
     * _setBurnFee is parameter is used to set burn fee when circulationg supply reaches certain limit
     */ 
    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        uint256 billion= 999200 * 10**9;
        uint256 hundredmillion=999000 *10**9;
        if(_tTotal <= billion && _tTotal >= hundredmillion)
        {
            _setBurnFee(2);
        }else if(_tTotal<hundredmillion){
            _setBurnFee(0);
        }
        if(sender == treasuryaddress || recipient == treasuryaddress){
            _transferFromtreasury(sender,recipient,amount);
        }
       
        else{
        if(sender != owner() && recipient != owner())
            require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
       
        if (_isrewardExcluded[sender] && !_isrewardExcluded[recipient]) {
            _transferFromrewardExcluded(sender, recipient, amount);
        } else if (!_isrewardExcluded[sender] && _isrewardExcluded[recipient]) {
            _transferTorewardExcluded(sender, recipient, amount);
        } else if (!_isrewardExcluded[sender] && !_isrewardExcluded[recipient]) {
            _transferStandard(sender, recipient, amount);
        } else if (_isrewardExcluded[sender] && _isrewardExcluded[recipient]) {
            _transferBothrewardExcluded(sender, recipient, amount);
        } 
        else {
            _transferStandard(sender, recipient, amount);
        }
        }
        
    }
	/**
	@dev
	  multiTransfer transfers tokens to Multiple Holders address
	*/
    function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
    for (uint256 i = 0; i < receivers.length; i++)
      transfer(receivers[i], amounts[i]);
    }
   /** @dev
    *  _transferStandard invoke when token is transferred from owner to recipient
    *   while transferring PAI token _transferTorewardExcluded is  invokes from transfer function,
	    when it satisfies this condition  (!_isrewardExcluded[sender] && _isrewardExcluded[recipient])
    *   while transferring PAI token _transferFromrewardExcluded is  invokes from transfer function,
	    when it satisfies this condition  (_isrewardExcluded[sender] && !_isrewardExcluded[recipient])
    *   while transferring PAI token _transferBothrewardExcluded is  invokes from transfer function,
	    when it satisfies this condition (_isrewardExcluded[sender] && _isrewardExcluded[recipient])
	  
	  
*/
   
    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
       uint256 treasuryamount = tAmount .mul(2).div(treasuryhundres);
      _rOwned[treasuryaddress] = _rOwned[treasuryaddress].add(treasuryamount);
        uint256 rBurn =  tBurn.mul(currentRate);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);      
        _paiFee(rFee, rBurn, tFee, tBurn);
        emit Transfer(sender, recipient, tTransferAmount);
        emit Transfer(sender, treasuryaddress, treasuryamount);
    }
    

    function _transferTorewardExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount,,,,,) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rAmount);          
         emit Transfer(sender, recipient, tAmount);
    }

    function _transferFromrewardExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount,,,,,) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rAmount);  
        emit Transfer(sender, recipient, tAmount);
    }
    
     function _transferFromtreasury(address sender, address recipient, uint256 tAmount) private {
       uint256 currentRate =  _getRate();
       uint256 rBurn =  tAmount.mul(currentRate);
       _rOwned[sender] = _rOwned[sender].sub(tAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rBurn);   
        emit Transfer(sender, recipient, tAmount);
    }
    
    

    function _transferBothrewardExcluded(address sender, address recipient, uint256 tAmount) private {
         (uint256 rAmount,,,,,) = _getValues(tAmount);
         _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rAmount);        
        emit Transfer(sender, recipient, tAmount);
    }

    function _paiFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
        _rTotal = _rTotal.sub(rFee).sub(rBurn);
        _tTaxTotal = _tTaxTotal.add(tFee);
        _tBurnTotal = _tBurnTotal.add(tBurn);
        _tTotal = _tTotal.sub(tBurn);
    }

    function _getValues(uint256 tAmount)private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _taxFee, _burnFee);
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
    }

    function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
        uint256 tFee = tAmount.mul(taxFee).div(100);
        uint256 tBurn = tAmount.mul(burnFee).div(100);
        uint256 tval = tAmount.mul(99).div(100);
        uint256 tTransferAmount = tval.sub(tFee).sub(tBurn);
        return (tTransferAmount, tFee, tBurn);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rBurn = tBurn.mul(currentRate);
        uint256 val = rAmount.mul(99).div(100);
        uint256 rTransferAmount = val.sub(rFee).sub(rBurn);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;      
        for (uint256 i = 0; i < _rewardExcluded.length; i++) {
            if (_rOwned[_rewardExcluded[i]] > rSupply || _tOwned[_rewardExcluded[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_rewardExcluded[i]]);
            tSupply = tSupply.sub(_tOwned[_rewardExcluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }
    
     /**
     * @dev sets the TaxFee for the token.
     */
    function _setTaxFee(uint256 taxFee) external onlyOwner() {
        require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
        _taxFee = taxFee;
    }
    
    /**
     * @dev Returns the TaxFee for the token.
     */
    function _getTaxFee() private view returns(uint256) {
        return _taxFee;
    }
     /**
     * @dev sets the BurnFee for the token.
     */
    function _setBurnFee(uint256 burnFee) internal  {
        _burnFee = burnFee;
    }
    /**
     * @dev get the BurnFee for the token.
     */
   function _getBurnFee() public view returns(uint256) {
        return _burnFee;
    }
  
    /**
     * @dev sets the maxTxAmount for the token.
     */
    function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
        require(maxTxAmount >= 9000e9 , 'maxTxAmount should be greater than 9000e9');
        _maxTxAmount = maxTxAmount;
    }
    /**
     * @dev Returns the MaxtransferAmount for the token.
     */
    function _getMaxTxAmount() private view returns(uint256) {
        return _maxTxAmount;
    }
}
