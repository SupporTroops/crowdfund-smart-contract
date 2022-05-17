const IERC20 = artifacts.require("IERC20");
const CrowdFund = artifacts.require("CrowdFund");
const Campaign = artifacts.require("Campaign");
// const web3 = require("web3");

const CONTRACT_ADDRESS = "0x35c5c801a1505EB65862BB440aa2b0264C2361E2";
const DAI = "0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa";
const WDAI = "0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735";
const ACCOUNT_ADDRESS = "0xDd2EDB40bb012182C057c23c7812058674F5232c";
let CAMPAIGN_ADDRESS = "0";

contract("IERC20", (accounts) => {
    // it("check acc balance", async () => {
    //     let token = await IERC20.at(DAI);
    //     const bal = await token.balanceOf(ACCOUNT_ADDRESS);
    //     console.log(bal.toString());
    // });

    /*
        const abi = [{"inputs":[{"internalType":"uint256","name":"chainId_","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"src","type":"address"},{"indexed":true,"internalType":"address","name":"guy","type":"address"},{"indexed":false,"internalType":"uint256","name":"wad","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":true,"inputs":[{"indexed":true,"internalType":"bytes4","name":"sig","type":"bytes4"},{"indexed":true,"internalType":"address","name":"usr","type":"address"},{"indexed":true,"internalType":"bytes32","name":"arg1","type":"bytes32"},{"indexed":true,"internalType":"bytes32","name":"arg2","type":"bytes32"},{"indexed":false,"internalType":"bytes","name":"data","type":"bytes"}],"name":"LogNote","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"src","type":"address"},{"indexed":true,"internalType":"address","name":"dst","type":"address"},{"indexed":false,"internalType":"uint256","name":"wad","type":"uint256"}],"name":"Transfer","type":"event"},{"constant":true,"inputs":[],"name":"DOMAIN_SEPARATOR","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"PERMIT_TYPEHASH","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"address","name":"","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"usr","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"usr","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"burn","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"guy","type":"address"}],"name":"deny","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"usr","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"mint","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"src","type":"address"},{"internalType":"address","name":"dst","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"move","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"nonces","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"holder","type":"address"},{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"nonce","type":"uint256"},{"internalType":"uint256","name":"expiry","type":"uint256"},{"internalType":"bool","name":"allowed","type":"bool"},{"internalType":"uint8","name":"v","type":"uint8"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"}],"name":"permit","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"usr","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"pull","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"usr","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"push","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"guy","type":"address"}],"name":"rely","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"dst","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"src","type":"address"},{"internalType":"address","name":"dst","type":"address"},{"internalType":"uint256","name":"wad","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"version","outputs":[{"internalType":"string","name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"wards","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"}];
         let contract = new web3.eth.Contract(abi, WDAI);
         contract.methods.approve(CONTRACT_ADDRESS, String(10**18)).send({from: ACCOUNT_ADDRESS});
    */
    // it("approve transfer", async () => {
    //     let token = await IERC20.at(DAI);
    //     const apr = await token.approve(CONTRACT_ADDRESS, String(10**18), {from: ACCOUNT_ADDRESS})
    //     console.log('apr', JSON.stringify(apr))
    // });

    // it("check allowance", async () => {
    //     let token = await IERC20.at(DAI);
    //     const allowance = await token.allowance(ACCOUNT_ADDRESS, CONTRACT_ADDRESS);
    //     console.log(allowance.toString());
    // });
});

contract("CrowdFund", async (accounts) => {
    it("create campaign", async () => {
        const crowdfund = await CrowdFund.at(CONTRACT_ADDRESS);
        const res = await crowdfund.create_campaign("test1", "This is a test campaign", false, ["0xDd2EDB40bb012182C057c23c7812058674F5232c", "0x0f88b67AD734aE43bA7E29974853653B9c3f5541"], ["10000000000000", "5000000000000"]);
        console.log(res.logs);
        CAMPAIGN_ADDRESS = res.logs[0].args.campaign_address;
    });

    it("show campaigns", async () => {
        const crowdfund = await CrowdFund.at(CONTRACT_ADDRESS);
        const res = await crowdfund.return_all_campaigns();
        console.log(JSON.stringify(res));
    });

    it("send eth to campaign", async () => {
        const crowdfund = await CrowdFund.at(CONTRACT_ADDRESS);
        const res = await crowdfund.recieveDonations(CAMPAIGN_ADDRESS, "ETH", String(10**5), { value: String(10**5) });
        console.log(res.logs[0]);
    });

    // it("send token to campaign", async () => {
    //     const crowdfund = await CrowdFund.at(CONTRACT_ADDRESS);
    //     const res = await crowdfund.recieveDonations(CAMPAIGN_ADDRESS, "WDAI", String(10 ** 15), { from: ACCOUNT_ADDRESS });
    //     console.log(res.logs);
    // })

    it("end campaign", async () => {
        const crowdfund = await CrowdFund.at(CONTRACT_ADDRESS);
        const res = await crowdfund.end_campaign(CAMPAIGN_ADDRESS, "Time expired", false);
        console.log(JSON.stringify(res));
    });

    it("check campaign balance", async () => {
        const campaign = await Campaign.at(CAMPAIGN_ADDRESS);
        const bal = await campaign.get_dai_balance();
        console.log(bal.toString())
    });

    it("check remaining amount", async () => {
        const campaign = await Campaign.at(CAMPAIGN_ADDRESS);
        const bal = await campaign.get_remaining_amount();
        console.log(bal.toString())
    });

});