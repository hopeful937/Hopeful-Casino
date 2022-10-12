const VRFNumberGenerators = artifacts.require('VRFNumberGenerators')
const CoinFlipper = artifacts.require('CoinFlipper')
require('dotenv').config()

require('chai')
.use(require('chai-as-promised'))
.should()

contract('VRFNumberGenerators', ([owner, user]) => {
    let numGen

    before(async () => {
        //load contract
        numGen = await VRFNumberGenerators.new(6995)
    })

    describe('Random Coin Flips', async () => {
        it('Flips the coin', async () => {
            let coin = await numGen.flipCoin()
            expect(coin).to.be.a('boolean')
        })  
    })
})

contract('CoinFlipper', ([owner, customer]) => {
    let coinFlip

    before(async () => {
        //load contract
        coinFlip = await CoinFlipper.new()
    })

    describe('Bet Functions', async () => {
        it('Places a bet', async () => {
            //init with a bet of 1k then check that the 1k bet is there
            await coinFlip.placeBet(500, 1000, true)
            let testBet = await coinFlip.getBet();
            assert.equal(testBet.betAmount, 1000)
        })
        it('Resets a bet when asked', async () => {
            //after reset, testBet should be 0
            await coinFlip.resetBet();
            let testBet = await coinFlip.getBet();
            assert.equal(testBet.betAmount, 0)
        })
    })

    describe('Coin Flip Functions', async () => {
        it('Can Perform a Coin Flip', async () => {
            let flipped = await coinFlip.performFlip.call(750, false, {from: customer})
            expect(flipped).to.be.a('boolean')
        })  
        it('Updates Statistics After 10 Flips (5h/5t)', async () => {
            let stats = await coinFlip.testStats.call({from: customer})
            assert.equal(parseInt(stats.correctPercent), 50)
        })
    })
})