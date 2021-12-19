const Migrations = artifacts.require("Final13");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
