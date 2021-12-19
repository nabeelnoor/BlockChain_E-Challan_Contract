const Migrations = artifacts.require("Final9");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
