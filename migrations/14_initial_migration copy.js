const Migrations = artifacts.require("Final12");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
