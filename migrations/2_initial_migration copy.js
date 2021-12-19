const Migrations = artifacts.require("Main");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
