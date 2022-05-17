// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

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
    function allowance(address owner, address spender) external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
}

library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

contract CrowdFund{
    address public owner;
    IUniswap uniswap;
    mapping(string => address) public TOKEN_ADDRESSES;

    event CreateCampaign(address creator, address campaign_address, string _cName, string _desc, bool _cType, address[] _vAddresses, uint[] _vAmounts);
    event EndCampaign(address campaign_address, string end_reason);
    event DonationRecieved(address donor_address, address campaign_address, string tokenIn, uint amountIn, string tokenOut, uint amountOut, uint amount_remaining);

    constructor(address _uniswapRouter) public {
        uniswap = IUniswap(_uniswapRouter);
        owner = msg.sender;
        TOKEN_ADDRESSES["DAI"] = 0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa;
        TOKEN_ADDRESSES["WDAI"] = 0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735;
    }

    Campaign[] public campaigns;

    function end_campaign(address campaign_address, string memory end_reason, bool is_amount_raised) public {
        Campaign campaign = Campaign(campaign_address);
        require(campaign.campaignerAddress() == msg.sender, "Only campaign owner can end campaign");
        campaign.end_campaign(is_amount_raised);
        emit EndCampaign(campaign_address, end_reason);
    }
    
    function recieveDonations(address campaign_address, string memory tokenIn, uint amount) public payable {
        Campaign camp = Campaign(campaign_address);
        require(camp.campaignEnded() != true, "Campaign already ended");
        // get the amount and swap it to DAI using Uniswap
        if (msg.value > 0 && TOKEN_ADDRESSES[tokenIn] == address(0)) {
            // swapExactEthforToken
            require(msg.value >= amount, "The ETH sent is less than amount");
            address[] memory path = new address[](2);
            path[0] = uniswap.WETH();
            path[1] = TOKEN_ADDRESSES["DAI"];
            uint[] memory amounts = uniswap.swapExactETHForTokens{ value: msg.value }(0, path, campaign_address, block.timestamp);
            camp.addDonation(msg.sender, amounts[amounts.length - 1]);
            emit DonationRecieved(msg.sender, campaign_address, tokenIn, msg.value, "DAI", amounts[amounts.length - 1], camp.get_remaining_amount());
        } else{
            // swapExactTokenforToken
            IERC20 token = IERC20(TOKEN_ADDRESSES[tokenIn]);
            require(token.balanceOf(msg.sender) >= amount, "Insufficient balance");
            uint allowance = token.allowance(msg.sender, address(this));
            require(allowance >= amount, "Insufficient allowance");
            token.transferFrom(msg.sender, address(this), amount);
            address[] memory path = new address[](3);
            path[0] = TOKEN_ADDRESSES[tokenIn];
            path[1] = uniswap.WETH();
            path[2] = TOKEN_ADDRESSES["DAI"];
            if(path[0] == path[2]){
                // Sending DAI
                token.transfer(campaign_address, amount);
                camp.addDonation(msg.sender, amount);
                emit DonationRecieved(msg.sender, campaign_address, tokenIn, amount, "DAI", amount, camp.get_remaining_amount());
            }else {
                token.approve(address(uniswap), amount);
                uint[] memory amounts = uniswap.swapExactTokensForTokens(amount, 0, path, campaign_address, block.timestamp);
                camp.addDonation(msg.sender, amounts[amounts.length - 1]);
                emit DonationRecieved(msg.sender, campaign_address, tokenIn, amount, "DAI", amounts[amounts.length - 1], camp.get_remaining_amount());
            }
        }
        if(camp.get_remaining_amount() == 0) {
            end_campaign(campaign_address, "Amount Raised", true);
        }
    }

    function create_campaign(string memory _cName, string memory _desc, bool _cType, address[] memory _vAddresses, uint[] memory _vAmounts) public returns(address) {
        // create campaign
        Campaign new_campaign = new Campaign(_cName, _desc, msg.sender, _cType, _vAddresses, _vAmounts);
        campaigns.push(new_campaign);
        emit CreateCampaign(msg.sender, address(new_campaign), _cName, _desc, _cType, _vAddresses, _vAmounts);
        return address(new_campaign);
    }
    
    function return_all_campaigns() external view returns(Campaign[] memory) {
        return campaigns;
    }

}

contract Campaign{

    string public campaignName;
    string public campaignDescription;
    address public campaignerAddress;
    enum CampaignType{ NonProfit, Profit}
    CampaignType public campaignType;
    mapping(address => uint) public vendorsDetails;
    address[] vendorList;
    mapping(address => uint) public donations;
    address[] donorList;
    uint public amountToRaise = 0;
    bool public campaignEnded;
    address DAI = 0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa;

    event FundTransfers(address campaign_address, address vendor_address, uint amount, string trans_type);

    modifier campaignNotEnded {
        require(!campaignEnded, "Campaign Ended cannot access these methods");
        _;
    }

    constructor(string memory _cName,
        string memory _desc,
        address _crAddress,
        bool _cType,
        address[] memory _vAddresses,
        uint[] memory _vAmounts
    ) public {
        campaignName = _cName;
        campaignDescription = _desc;
        campaignerAddress = _crAddress;
        campaignType = _cType ? CampaignType.Profit : CampaignType.NonProfit;
        vendorList = _vAddresses;
        for (uint i=0; i<_vAddresses.length; i++) {
            vendorsDetails[_vAddresses[i]] = _vAmounts[i];
            amountToRaise = amountToRaise + _vAmounts[i];
        }
        campaignEnded = false;
    }

    function addDonation(address donor, uint amount) public campaignNotEnded {
        donorList.push(donor);
        donations[donor] = amount;
    }

    function getCampaignDetails() external view returns(string memory, string memory, address, bool, address[] memory, uint[] memory, address[] memory, uint[] memory, bool) {
        uint[] memory vendor_amounts = new uint[](vendorList.length);
        for (uint i = 0; i < vendorList.length; i++) {
            uint amount = vendorsDetails[vendorList[i]];
            vendor_amounts[i] = amount;
        }
        uint[] memory donor_amounts = new uint[](donorList.length);
        for (uint i = 0; i < donorList.length; i++) {
            uint amount = donations[donorList[i]];
            donor_amounts[i] = amount;
        }
        bool ctype = campaignType == CampaignType.Profit;
        return (campaignName, campaignDescription, campaignerAddress, ctype, vendorList, vendor_amounts, donorList, donor_amounts, campaignEnded);
    }

    function end_campaign(bool is_amount_raised) external campaignNotEnded {
        campaignEnded = true;
        if(is_amount_raised) {
            // transfer funds to vendors
            for (uint vi = 0; vi < vendorList.length; vi++) {
                address vendorAddress = vendorList[vi];
                uint amount = vendorsDetails[vendorAddress];
                IERC20(DAI).transfer(vendorAddress, amount);
                emit FundTransfers(address(this), vendorAddress, amount, "Payment to vendor");
            }
        } else {
            for (uint vi = 0; vi < donorList.length; vi++) {
                address donorAddress = donorList[vi];
                uint amount = donations[donorAddress];
                IERC20(DAI).transfer(donorAddress, amount);
                emit FundTransfers(address(this), donorAddress, amount, "Refund to Donor");
            }
        }
    }

    function get_dai_balance() public view returns(uint) {
        IERC20 dai = IERC20(DAI);
        uint256 balance = dai.balanceOf(address(this));
        return balance;
    }

    function get_remaining_amount() public view campaignNotEnded returns(uint) {
        uint bal = get_dai_balance();
        if (bal < amountToRaise) {
            return amountToRaise - bal;
        }else {
            return 0;
        }
    }
}