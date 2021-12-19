const Migrations = artifacts.require("Final11");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
