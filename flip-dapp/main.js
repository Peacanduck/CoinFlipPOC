var web3 = new Web3(Web3.givenProvider);
var contractInstance;

$(document).ready(function() {
    window.ethereum.enable().then(function(accounts){
      contractInstance = new web3.eth.Contract(abi,"0x755006F7e3aEAFbFA4F42bB7cDC05B375Dad35BE",{from:accounts[0]});
      console.log(contractInstance);
    });
    $("#heads_button").click(callHeads)
    $("#tails_button").click(callTails)
});

function callHeads(){
  var bet = $("#bet_input").val();
  var x = 1;
  var config = {
    value: web3.utils.toWei(""+bet,"ether")
  }
  contractInstance.methods.flip(x).send(config).on("transactionHash",function(hash){
    console.log(hash);
    $("#dis_output").text("loading result")
  }).on("confirmation",(confirmationNr) =>{
    console.log(confirmationNr);
    $("#dis_output").text(confirmationNr);
  }).on("receipt",(receipt) => {
    console.log(receipt);
  })
/**/  contractInstance.events.res(function(error, result){
              if (!error)
                  {
                    console.log(result)
              $("#dis_game_output").text(result.returnValues.blurb);
                  } else {
                      console.log(error);
                  }
          });
  }

  function callTails() {
    var bet = $("#bet_input").val();
    var x = 0;
    var config = {
      value: web3.utils.toWei(""+bet,"ether")
    }

    contractInstance.methods.flip(x).send(config).on("transactionHash",function(hash){
      console.log(hash);
    }).on("confirmation",(confirmationNr) =>{
      console.log(confirmationNr);
      $("#dis_output").text(confirmationNr);
    }).on("receipt",(receipt) => {
      console.log(receipt);

    })
    contractInstance.events.res(function(error, result){
                  if (!error)
                      {
                        console.log(result)
                  $("#dis_game_output").text(result.returnValues.blurb);
                      } else {
                          console.log(error);
                      }
              });
}
