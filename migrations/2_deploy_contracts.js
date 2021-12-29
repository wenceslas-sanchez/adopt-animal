var AnimalFeeding = artifacts.require("AnimalFeeding");


module.exports = function(deployer) {
    deployer.deploy(AnimalFeeding);
};