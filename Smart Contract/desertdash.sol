// Desert Dash - A Massive Multiplayer Blockchain Boardgame
// desertdash.fun
// twitter.com/desertdash_fun
// reddit.com/user/glov
pragma solidity ^0.4.21;

contract desertdash {
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    address public owner;
    
    mapping (address => uint) myNumber;
    mapping (address => uint) myDice;
    mapping (address => uint) winners;
    mapping (address => uint) playerReady;
    mapping (address => uint) myGame;
    mapping (address => uint) doubleDice;
    mapping (address => uint) public myAddress;
    uint currentRound;
    uint entranceFee;
    uint startBlock;
    uint gameOn;
    uint totalWinners;
    uint totalPlayers;
    uint totalPlaying;
    uint furthestPlayer;
    
    function desertdash () public {
        owner = msg.sender;
        entranceFee = 0.000001 ether;
        startBlock = 99999999999999999;
        currentRound = 1;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
    
    function withdraw() external onlyOwner {
	    owner.transfer(this.balance);
	}
	
	function whatsMyInfo () view returns (uint, uint, uint, uint, int, uint, uint) {
	    uint _joinStatus = currentRound - myGame[msg.sender];
	    int _nextRoll = int((myDice[msg.sender] + 4) - block.number);
	    return (myNumber[msg.sender], playerReady[msg.sender], doubleDice[msg.sender], totalPlaying, _nextRoll, _joinStatus, furthestPlayer);
	}
	
	modifier pendingGame () {
	    require (myGame[msg.sender] < currentRound);
	    _;
	}
	
	function joinGame () external pendingGame {
	    uint _myAddress = uint(keccak256(msg.sender));
	    myAddress[msg.sender] = _myAddress;
	    myGame[msg.sender] = currentRound;
	    playerReady[msg.sender] = 0;
	    myNumber[msg.sender] = 0;
	    totalPlayers++;
	    if (totalPlayers == 1 && gameOn == 0) {
	    startBlock = (block.number + 20);
	    gameOn = 1;
	    }
	}
	
	modifier readyUpConditions () {
	    require (playerReady[msg.sender] == 0);
	    require (myGame[msg.sender] == currentRound);
	    _;
	}
	
	function readyUp () external readyUpConditions {
	    myDice[msg.sender] = block.number;
	    myNumber[msg.sender] = 1;
	    playerReady[msg.sender] = 1;
	    doubleDice[msg.sender] = 3;
	    totalPlaying++;
	}
	
	modifier currentGame () {
	    require (myGame[msg.sender] == currentRound);
	    require (playerReady[msg.sender] == 1);
	    require (gameOn == 1);
	    require (block.number - myDice[msg.sender] >= 4);
	    require (startBlock < block.number);
	    _;
	}
	
	function rollDice () external currentGame {
	    uint _myRoll = (uint(block.blockhash(myDice[msg.sender])) + myAddress[msg.sender]) % 6 + 1;
	    myNumber[msg.sender] += _myRoll;
        myDice[msg.sender] = (block.number);
        if (myNumber[msg.sender] == 11) {
            doubleDice[msg.sender]++;
        }
        if (myNumber[msg.sender] == 64) {
            doubleDice[msg.sender]++;
        }
        if (myNumber[msg.sender] == 90) {
            doubleDice[msg.sender]++;
        }
        if (myNumber[msg.sender] == 6) {
            myNumber[msg.sender] = 19;
        }
        if (myNumber[msg.sender] == 23) {
            myNumber[msg.sender] = 40;
        }
        if (myNumber[msg.sender] == 43) {
            myNumber[msg.sender] = 83;
        }
        if (myNumber[msg.sender] == 81) {
            myNumber[msg.sender] = 65;
        }
        if (myNumber[msg.sender] == 121) {
            myNumber[msg.sender] = 97;
        }
        if (myNumber[msg.sender] == 125) {
            myNumber[msg.sender] = 17;
        }
        if (myNumber[msg.sender] == 126) {
            winners[msg.sender] = 1;
            totalWinners++;
            if (totalWinners == 1) {
                gameOn = 0;
        	    totalPlayers = 0;
        	    totalWinners = 0;
        	    totalPlaying = 0;
        	    furthestPlayer = 0;
        	    startBlock = 99999999999999999;
        	    currentRound++;
            }
        }
        if (myNumber[msg.sender] > 126) {
            myNumber[msg.sender] -= _myRoll;
        }
        if (myNumber[msg.sender] > furthestPlayer) {
            furthestPlayer = myNumber[msg.sender];
        }
	}
	
	modifier twoDiceConditions () {
	    require (myGame[msg.sender] == currentRound);
	    require (playerReady[msg.sender] == 1);
	    require (gameOn == 1);
	    require (block.number - myDice[msg.sender] >= 4);
	    require (startBlock < block.number);
	    require (doubleDice[msg.sender] > 0);
	    _;
	}
	
	function rollTwoDice () external twoDiceConditions {
	    doubleDice[msg.sender]--;
	    uint _myRoll = (uint(block.blockhash(myDice[msg.sender])) + myAddress[msg.sender]) % 11 + 2;
	    myNumber[msg.sender] += _myRoll;
        myDice[msg.sender] = (block.number);
        if (myNumber[msg.sender] == 11) {
            doubleDice[msg.sender]++;
        }
        if (myNumber[msg.sender] == 64) {
            doubleDice[msg.sender]++;
        }
        if (myNumber[msg.sender] == 90) {
            doubleDice[msg.sender]++;
        }
        if (myNumber[msg.sender] == 6) {
            myNumber[msg.sender] = 19;
        }
        if (myNumber[msg.sender] == 23) {
            myNumber[msg.sender] = 40;
        }
        if (myNumber[msg.sender] == 43) {
            myNumber[msg.sender] = 83;
        }
        if (myNumber[msg.sender] == 81) {
            myNumber[msg.sender] = 65;
        }
        if (myNumber[msg.sender] == 121) {
            myNumber[msg.sender] = 97;
        }
        if (myNumber[msg.sender] == 125) {
            myNumber[msg.sender] = 17;
        }
        if (myNumber[msg.sender] == 126) {
            winners[msg.sender] = 1;
            totalWinners++;
            if (totalWinners == 1) {
                gameOn = 0;
        	    totalPlayers = 0;
        	    totalWinners = 0;
        	    totalPlaying = 0;
        	    furthestPlayer = 0;
        	    startBlock = 99999999999999999;
        	    currentRound++;
            }
        }
        if (myNumber[msg.sender] > 126) {
            myNumber[msg.sender] -= _myRoll;
        }
        if (myNumber[msg.sender] > furthestPlayer) {
            furthestPlayer = myNumber[msg.sender];
        }
	}
}