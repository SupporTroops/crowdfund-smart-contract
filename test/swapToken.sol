// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

interface IUniswap {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external
    returns (uint[] memory amounts);

    function WETH() external pure returns (address);

    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to, uint deadline
    ) external 
    payable
    returns (uint[] memory amounts);


}

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract A {
    event e(uint bal);
    function pay() payable external {
        emit e(msg.value);
    }

    function ch() public {
        emit e(address(this).balance);
    }
}

contract Storage {

    IUniswap uniswap;
    mapping(string => address) tokenAddresses;
    A a;
    constructor(address _uniswapRouter) {
        uniswap = IUniswap(_uniswapRouter);
        tokenAddresses["DAI"] = 0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735;
        tokenAddresses["cUSDT"] = 0xD9BA894E0097f8cC2BBc9D24D308b98e36dc6D02;
        tokenAddresses["UNI"] = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
        tokenAddresses["REP"] = 0x930B647320F738D92f5647B2E5C4458497Ce3c95;
    }

    event bal(address sender, uint balance);
    event SwappedAmount(address sender, string tokenIn, string tokenOut, uint amountIn, uint amountOut );

    // function trnsfFrom() external {
    //     emit bal(msg.sender, IERC20(token).balanceOf(msg.sender));
    //     require(IERC20(token).balanceOf(msg.sender) > 9000000, "Insufficient bal");
    //     IERC20(token).transferFrom(msg.sender, address(this), 9000000);
    // }

    function swapExactETHforToken(string memory tokenOut) external payable {
        require(msg.value != 0, "No amount sent");
        address[] memory path = new address[](2);
        path[0] = uniswap.WETH();
        path[1] = tokenAddresses[tokenOut];
        uint[] memory amounts = uniswap.swapExactETHForTokens{ value: msg.value }(0, path, address(this), block.timestamp);
        emit SwappedAmount(msg.sender, "ETH", tokenOut, msg.value, amounts[amounts.length - 1]);
    }


    function check() external payable {
        a.pay{ value: msg.value }();
    }

    function swapExactTokensForTokens(
        string memory tokenIn, // 0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735
        string memory tokenOut, // 0xD9BA894E0097f8cC2BBc9D24D308b98e36dc6D02
        uint amountIn,
        uint amountOutMin,
        uint deadline
    ) external {
        IERC20 token = IERC20(tokenAddresses[tokenIn]);
        require(token.balanceOf(msg.sender) >= amountIn, "Insufficient balance in user account");
        token.transferFrom(msg.sender, address(this), amountIn);
        address[] memory path = new address[](3);
        path[0] = tokenAddresses[tokenIn];
        path[1] = uniswap.WETH();
        path[2] = tokenAddresses[tokenOut];
        token.approve(address(uniswap), amountIn);
        uniswap.swapExactTokensForTokens(amountIn, amountOutMin, path, address(this), deadline);
    }

    function getBalance(string memory token) external returns(uint){
        uint balanc = IERC20(tokenAddresses[token]).balanceOf(msg.sender);
        emit bal(msg.sender, balanc);
        return balanc;
    }
}