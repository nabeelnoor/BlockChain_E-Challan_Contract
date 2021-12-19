const Migrations = artifacts.require("Final7");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
