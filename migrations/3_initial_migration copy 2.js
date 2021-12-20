const Migrations = artifacts.require("FinalB");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
