// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title UniswapV2Factory
 * @notice Minimal interface for interacting with a Uniswap V2 Factory contract.
 * @dev Used to retrieve the liquidity pair address for two tokens.
 */
interface UniswapV2Factory {
    /**
     * @notice Returns the pair contract address for two tokens.
     * @param tokenA Address of the first token.
     * @param tokenB Address of the second token.
     * @return pair Address of the liquidity pair contract.
     */
    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);
}

/**
 * @title UniswapV2Pair
 * @notice Minimal interface for interacting with a Uniswap V2 Pair contract.
 * @dev A pair contract stores liquidity reserves for two tokens.
 */
interface UniswapV2Pair {
    /**
     * @notice Returns the current reserves held by the pair.
     * @return reserve0 Reserve amount of token0.
     * @return reserve1 Reserve amount of token1.
     * @return blockTimestampLast Timestamp of the last reserve update.
     */
    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

/**
 * @title UniswapExample
 * @notice Demonstrates how to read token reserves from a Uniswap V2 liquidity pool.
 * @dev The contract:
 *      1. Retrieves the DAI/WETH pair address from the Uniswap Factory.
 *      2. Reads the liquidity reserves from the pair contract.
 */
contract UniswapExample {
    /// @dev Address of the Uniswap V2 Factory contract on Ethereum Mainnet.
    address private factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;

    /// @dev Address of the DAI token on Ethereum Mainnet.
    address private dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    /// @dev Address of the WETH token on Ethereum Mainnet.
    address private weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    /**
     * @notice Retrieves the liquidity reserves of the DAI/WETH pool.
     * @return reserve0 Reserve amount of token0 in the pair contract.
     * @return reserve1 Reserve amount of token1 in the pair contract.
     * @dev The function first finds the pair address using the factory,
     *      then queries the pair contract for its reserves.
     *
     *      Note:
     *      token0 and token1 are determined by the pair contract and
     *      may not match the order of dai and weth specified above.
     */
    function getTokenReserves()
        external
        view
        returns (uint256 reserve0, uint256 reserve1)
    {
        // Retrieve the DAI/WETH pair contract address from the factory.
        address pair = UniswapV2Factory(factory).getPair(dai, weth);

        // Read the current liquidity reserves from the pair contract.
        (reserve0, reserve1, ) = UniswapV2Pair(pair).getReserves();

        return (reserve0, reserve1);
    }
}
