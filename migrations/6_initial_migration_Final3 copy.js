const Migrations = artifacts.require("Final4");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
