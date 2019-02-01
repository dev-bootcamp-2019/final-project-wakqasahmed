var StringUtils = artifacts.require("../libraries/StringUtils.sol");
var SafeMath = artifacts.require("../libraries/SafeMath.sol");
var Merchandise = artifacts.require("./Merchandise.sol");

async function doDeploy(deployer) {
    await deployer.deploy(StringUtils);
    await deployer.deploy(SafeMath);
    await deployer.link(StringUtils, Merchandise);
    await deployer.link(SafeMath, Merchandise);    
    await deployer.deploy(Merchandise);
}

module.exports = function(deployer) {
    deployer.then(async () => {
        await doDeploy(deployer);
    });
};