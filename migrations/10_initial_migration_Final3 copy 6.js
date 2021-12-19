const Migrations = artifacts.require("Final8");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
