// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

//import Chainlink VRFv2
import '../github/smartcontractkit/chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol';
import '../github/smartcontractkit/chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol';
import '../github/smartcontractkit/chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol';

contract VRFNumberGenerators is VRFConsumerBaseV2 {
    VRFCoordinatorV2Interface Coordinator;

    //Subscription ID for calling from VRF
    uint64 sub_ID;

    //Rinkleby testnet coordinator address
    address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;

    //Gas lane (sets max gas usage)
    bytes32 keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;

    //storing each word costs ~20k gas, planning on storing one word
    uint32 callbackGasLimit = 40000;
    uint16 requestConfirmations = 3;
    uint32 numWords = 1;

    uint256[] public s_randomWords;
    uint256 public s_requestId;
    address s_owner;

    //Create VRF base
    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        Coordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        sub_ID = subscriptionId;
    }

    //Currently assumes subscription is properly funded
    //will change in future
    function requestRandomWords() internal onlyOwner {
        // Will revert if subscription is not set and funded.
        s_requestId = Coordinator.requestRandomWords(
            keyHash,
            sub_ID,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords
    ) internal override{
        s_randomWords = randomWords;
    }

    // Generates a random word then calculates mod 2 of the word to flip a coin
    // If the number was even (x mod 2 = 0) return false (tails)
    // If the number was odd (else, mod 2 can only be 1 or 0) return true (heads)
    function flipCoin() external view returns(bool coin){
        //@dev TEMPORARY SOLUTION TO VRF BEING ANNOYING
        //@dev PLEASE IMPLEMENT VRF PROPERLY BEFORE FINAL DEPLOYEMENT
        //@dev DUMBASS 
        uint ranNum = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 2;
        if(ranNum == 0) coin = false;
        else coin = true;
        return coin;
    }

    modifier onlyOwner() {
        require(msg.sender == s_owner);
        _;
    }
}
