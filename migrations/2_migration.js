const Flip = artifacts.require("Flip");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Flip).then(function(instance){
    instance.init({value: 1000000000000000000, from: accounts[0]}).then(function(){
        console.log("Success");
}).catch(function(err){
  console.log("error"+err);
});
}).catch(function(err){
  console.console.log("Deploy failed"+err);
});
};
