const Migrations = artifacts.require("Final2");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
