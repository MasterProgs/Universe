// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./interfaces/IJoeRouter.sol";

contract RouterFuji {
    using SafeERC20 for IERC20;

    IJoeRouter02 private router;

    IERC20 private leftSide;
    IERC20 private rightSide;

    constructor(
        address _router,
        address[2] memory path
    ) {
        require(
            _router != address(0),
            "LiquidityPoolManager: Router cannot be undefined"
        );
        leftSide = IERC20(path[0]);
        rightSide = IERC20(path[1]);
        router = IJoeRouter02(_router);
    }

    function addLiquidityToken(uint256 leftAmount, uint256 rightAmount) external {
        router.addLiquidity(
            address(leftSide),
            address(rightSide),
            leftAmount,
            rightAmount,
            0, // Slippage is unavoidable
            0, // Slippage is unavoidable
            address(this),
            block.timestamp + 60 // 1 min
        );
    }

    function isRouter(address _router) public view returns (bool) {
        return _router == address(router);
    }
}