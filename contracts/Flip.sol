pragma solidity 0.5.12;
import "./provableAPI.sol";
contract Flip is usingProvable{

      uint256 constant NUM_RANDOM_BYTES_REQUESTED = 1;
      uint public contractBalance;
      uint256 public latestNumber;

      struct Game {
        address player;
        uint result;
        bool status;
        uint bet;
        uint playerCalled;
      }

  mapping (bytes32 => Game) private gamePool;

      event LogNewProvableQuery(string description);
      event LogGeneratedRandomNumber(uint256 randomNumber);

      event res(string blurb);
      event Sent(address to, uint amount);

      constructor() public{
          contractBalance = 0;
          //requestRandom();
      }

      function init() public payable{
          contractBalance += msg.value;
      }

      function checkWin(uint bet,uint  result) private returns(bool){
          require(bet == uint(1) || bet == uint(0));

          if(result == bet){
              emit res("you win");
              return true;
          }else{
              emit res("you lost");
           return false;
          }
      }

          function __callback(bytes32  _queryId,string memory _result,bytes memory _proof) public {
           require(msg.sender == provable_cbAddress());

           uint256 randomNumber = uint256(keccak256(abi.encodePacked(_result))) % 2;
           latestNumber = randomNumber;
           gamePool[_queryId].result = latestNumber;
           gamePool[_queryId].status = true;
           if(checkWin(gamePool[_queryId].playerCalled, latestNumber)){
             uint winnings = gamePool[_queryId].bet + gamePool[_queryId].bet;
               contractBalance -= winnings;
             address payable p = address(uint160(gamePool[_queryId].player));
             p.transfer(winnings);
           }
           emit LogGeneratedRandomNumber(randomNumber);
      }
      function flip(uint call) public payable {

          require(msg.value >= 100000000000000000,"the minimum bet is 100 finney");
          require(contractBalance >= 100000000000000000,"not enough funds in contract");

          uint value = msg.value;
          contractBalance += value;
          //requestRandom(call, msg.sender, value);
         uint256 QUERY_EXECUTION_DELAY = 0;
         uint256 GAS_FOR_CALLBACK = 200000;
         contractBalance -= GAS_FOR_CALLBACK;
         Game memory newGame;
         bytes32 queryId = provable_newRandomDSQuery(QUERY_EXECUTION_DELAY,NUM_RANDOM_BYTES_REQUESTED,GAS_FOR_CALLBACK);
         newGame.player = msg.sender;
         newGame.bet = value;
         newGame.status = false;
         newGame.playerCalled = call;
         gamePool[queryId] = newGame;
         emit LogNewProvableQuery("Provable query was sent, standing by for answer.");
      }

}
