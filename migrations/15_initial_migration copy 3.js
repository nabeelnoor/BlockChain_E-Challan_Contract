const Migrations = artifacts.require("Final14");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
