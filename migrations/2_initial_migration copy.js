const Migrations = artifacts.require("FinalA");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
