// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
/**
 * @title Thrift
 * @dev Set word & hint, Guess word
 */
contract GuessIsWon is Ownable{
	struct Participant {
		address player;
		bool won;
	}
	string private word;
	string public hint;
	address public lastWinner;
	
	Participant[] private players;

	// event for EVM logging
	event WordHintSet(string indexed wordHint);

	/**
	 * @dev Set word & hint
	 * @param _word word that will have to be found
	 * @param _hint hint to find the word
	 */
	function setWordHint(string memory _word, string memory _hint) public onlyOwner{
		word = _word;
		hint = _hint;
		if(lastWinner != address(0)){
			lastWinner = address(0);
		}
		if(players.length > 0){ 
			for(uint i = 0; i < players.length; i++){
				delete players[i];
			}
		}
		emit WordHintSet(string(abi.encodePacked(word,hint)));
	}

	/**
	 * @dev Guess word
	 * @param _word suggested word
	 */
	function guess(string memory _word) public returns (string memory result){
		for (uint i = 0; i < players.length; i++) {
			require(players[i].player == msg.sender, "You have already participated !" );
		}
		if (keccak256(abi.encodePacked((_word))) == keccak256(abi.encodePacked((word)))){
			players.push(Participant({player: msg.sender, won: true}));
			lastWinner = msg.sender;
			return "you win !";
		}else{
			players.push(Participant({player: msg.sender, won: false}));
			return "you loose !";
		}
	}
	
}