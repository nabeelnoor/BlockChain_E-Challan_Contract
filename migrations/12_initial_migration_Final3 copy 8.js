const Migrations = artifacts.require("Final10");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
