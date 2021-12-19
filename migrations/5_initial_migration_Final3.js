const Migrations = artifacts.require("Final3");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
