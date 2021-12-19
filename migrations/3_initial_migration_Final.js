const Migrations = artifacts.require("Final");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
