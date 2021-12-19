const Migrations = artifacts.require("Final5");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
