var VRFNumberGenerators = artifacts.require('VRFNumberGenerators')
var CoinFlipper = artifacts.require('CoinFlipper')

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(CoinFlipper, {from:accounts[2]})
    const coinFlip = await CoinFlipper.deployed()
    await deployer.deploy(VRFNumberGenerators, 6995, {from:accounts[2]})
    const vrfGen = await VRFNumberGenerators.deployed()
}