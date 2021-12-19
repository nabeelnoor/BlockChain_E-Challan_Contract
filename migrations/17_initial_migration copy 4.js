const Migrations = artifacts.require("ChallanSystem");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
