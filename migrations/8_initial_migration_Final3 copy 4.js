const Migrations = artifacts.require("Final6");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
