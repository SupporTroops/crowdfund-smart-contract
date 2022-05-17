const IERC20 = artifacts.require("IERC20");
const Storage = artifacts.require("Storage");

const STORAGE = "0x0b39b9873370fC12450fE3071a3071B8BE602c02";
const ACC = "0xDd2EDB40bb012182C057c23c7812058674F5232c";
const TOKENS = {
    DAI: "0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735",
    cUSDT: "0xD9BA894E0097f8cC2BBc9D24D308b98e36dc6D02",
    UNI: "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984",
    REP: "0x930B647320F738D92f5647B2E5C4458497Ce3c95"
}
contract("IERC20", (accounts) => {
    it("test", async () => {
        let token = await IERC20.at(TOKENS.UNI);
        // const apr = await token.approve(STORAGE, String(10 ** 20), {from: ACC})
        // console.log('apr', JSON.stringify(apr))
        // const bal = await token.balanceOf(ACC, {from: ACC})
        const bal = await token.balanceOf(STORAGE, {from: ACC})

        // const trsnf = await token.transfer(STORAGE, "4436250513726004157", {from: ACC})
        // console.log(`transfer: ${JSON.stringify(trsnf)}`);
        console.log(`bal: ${bal}`);
    })
});

contract("Storage", (accounts) => {
    // it("swap eth for token", async () => {
    //     const storage = await Storage.at(STORAGE);
    //     const res = await storage.swapExactETHforToken("UNI" ,{from: ACC, value: String(10 ** 18)})
    //     console.log(`res: ${JSON.stringify(res)}`);
    // })
})
