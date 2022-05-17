const CrowdFund = artifacts.require("CrowdFund");
const Campaign = artifacts.require("Campaign");

module.exports = function (deployer) {
    // uniswap router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
    deployer.deploy(CrowdFund, "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D");
    // deployer.deploy(Campaign, "test1", "This is a test campaign", false, ["0xDd2EDB40bb012182C057c23c7812058674F5232c", "0x0f88b67AD734aE43bA7E29974853653B9c3f5541"], ["100000000", "500000000"]);
};