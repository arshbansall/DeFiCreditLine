// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
}

contract CreditLine {
    IERC20 public immutable usdc;
    address public owner;

    mapping(address => uint256) public creditLimit;
    mapping(address => uint256) public debt;

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event CreditLimitSet(address indexed user, uint256 newLimit);
    event Draw(address indexed user, uint256 amount, uint256 newDebt);
    event Repay(address indexed user, uint256 amount, uint256 newDebt );

    error NotOwner();
    error ZeroAmount();
    error ExceedsLimit(uint256 limit, uint256 attemptedDebt);
    error RepayTooMuch(uint256 currentDebt, uint256 repayAmount);
    error ERC20TransferFailed();
    error InvalidAddress();

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    constructor(address usdcToken, address initialOwner) {
        if (usdcToken == address(0)) revert InvalidAddress();
        if (initialOwner == address(0)) revert InvalidAddress();

        usdc = IERC20(usdcToken);
        owner = initialOwner;
    }

    function setOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "OWNER=0");
        address old = owner;
        owner = newOwner;
        emit OwnerChanged(old, newOwner);
    }

    function setCreditLimit(address user, uint256 newLimit) external onlyOwner {
        require(user != address(0), "USER=0");
        creditLimit[user] = newLimit;
        emit CreditLimitSet(user, newLimit);
    }

    function draw(uint256 amount) external {
        if(amount == 0) revert ZeroAmount();
        uint256 newDebt = debt[msg.sender] + amount;
        uint256 limit = creditLimit[msg.sender];

        if(newDebt > limit) revert ExceedsLimit(limit, newDebt);

        debt[msg.sender] = newDebt;
        
        bool ok = usdc.transfer(msg.sender, amount);
        if (!ok) revert ERC20TransferFailed();

        emit Draw(msg.sender, amount, newDebt);
    }

    function repay(uint256 amount) external {
        if (amount == 0) revert ZeroAmount();

        uint256 currentDebt = debt[msg.sender];
        if (amount > currentDebt) revert RepayTooMuch(currentDebt, amount);

        uint256 newDebt = currentDebt - amount;
        debt[msg.sender] = newDebt;

        bool ok = usdc.transferFrom(msg.sender, address(this), amount);
        if (!ok) revert ERC20TransferFailed();

        emit Repay(msg.sender, amount, newDebt);
    }

    /// @notice Remaining credit available to draw right now
    function availableCredit(address user) external view returns (uint256) {
        uint256 limit = creditLimit[user];
        uint256 used = debt[user];
        if (used >= limit) return 0;
        return limit - used;
    }

    /// @notice Utilization in basis points (bps). 10,000 bps = 100%
    function utilizationBps(address user) external view returns (uint256) {
        uint256 limit = creditLimit[user];
        if (limit == 0) return 0;
        return (debt[user] * 10_000) / limit;
    }

    /// @notice USDC liquidity held by this contract
    function contractLiquidity() external view returns (uint256) {
        return usdc.balanceOf(address(this));
    }
}
