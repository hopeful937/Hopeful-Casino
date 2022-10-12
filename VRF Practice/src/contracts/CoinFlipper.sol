// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

// @dev if youre not Hopeful and know that the license id is wrong
// @dev i have no clue how its supposed to work so change it, whatever

import './VRFNumberGenerators.sol';

contract CoinFlipper {
    //Writing things out
    //Users can place a bet on heads or tails with a certain bet amount
    //when a user presses the button to flip a coin, performFlip() executes after bid is placed
    //CoinFlip from VRFNumGen executes and returns bool (performFlip will return this as well)
    //before returning that value, the following will be calculated:
    //correctBets, totalBets, correctPercent, global stats (stored in owner)
    address owner;
    VRFNumberGenerators numGen = new VRFNumberGenerators(6995); //evidently off of testnet subID cant be here
    uint256 betID;

    constructor() {
        owner = msg.sender;
        betID = 0;
    }

    //Stores a users current bet
    struct bet {
        address user;
        uint256 requestId;
        uint256 betId;
        uint256 betAmount;
        bool betCast;
        bool result;
    }
    bet currentBet;
    mapping(address => bet) currentBets;      //store bets in progress
    mapping(uint256 => bet) betHistory;       //store bets once completed

    //stores a users overall statistics
    //owner address will store global statistics
    struct statistics {
        uint256 correctBets;
        uint256 totalBets;
        uint256 correctPercent;
    }
    mapping(address => statistics) public userStatistics;

    //Creates a new bet, result init's to false until coinFlip is calculated
    function placeBet(uint256 requestId, uint256 betAmount, bool betCast) public {
        currentBet = bet(msg.sender, requestId, betID, betAmount, betCast, false);
        currentBets[msg.sender] = currentBet;
        betID++; //increment betID for the next unique bet
    }

    //After selecting a bet and pressing the flip coin button, perform the flip
    //True is heads, false is tails
    function performFlip(uint256 betAmount, bool predicted) public returns(bool result){
        //place bet
        //@dev using a temporary requestID until i know what that even is
        placeBet(575, betAmount, predicted);
        //perform coin flip
        result = numGen.flipCoin();
        //update statistics/other cleanup
        result == predicted ? updateStats(true) : updateStats(false);
        resetBet();
        return result;
    }
    
    //Resets user's current bet to default
    //Pass this function only after post-flip transactions complete
    function resetBet() public {
        currentBets[msg.sender] = bet(msg.sender, 0, 0, 0, false, false);
    }

    //Updates both user and global stats after a performFlip transaction
    function updateStats(bool betChoice) internal {
        userStatistics[msg.sender].totalBets++;
        userStatistics[owner].totalBets++;
        if(betChoice) {
            userStatistics[msg.sender].correctBets+=1;
            userStatistics[owner].correctBets++;
        }
        userStatistics[msg.sender].correctPercent = (userStatistics[msg.sender].correctBets * 100) / (userStatistics[msg.sender].totalBets);
        userStatistics[owner].correctPercent = (userStatistics[owner].correctBets * 100) / (userStatistics[owner].totalBets);
    }

    //functions for testing stuff bc lazy
    function getBet() external view returns(bet memory){
        //for testing
        return currentBets[msg.sender];
    }

    function testStats() external returns(statistics memory) {
        for(uint i = 0; i < 10; i++) {
            i < 5 ? updateStats(true) : updateStats(false);
        }
        return userStatistics[msg.sender];
    }

}