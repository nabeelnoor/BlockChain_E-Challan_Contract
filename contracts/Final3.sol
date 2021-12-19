// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Final3{
    enum VehicleType {Motorcycle,Motorcar,Jeep,PublicServiceVehicle,PrivateCarrier,PublicCarrier}

    struct Challan{
    string LicenseID; //license id of citizen
    string CitizenName; 
    string CitizenCNIC;
    VehicleType CarType; 
    string CarNumberPlate;
    uint[] VoilationCode;  //------list of voilated rules
    string timeStamp;
    uint Fine;
    bool status;
    }

    struct VoilationRule{
    string Description; //description of the rule
    uint[3] Fine;  
    /*
    0: ACategoryVehicle_Fine //includes Motorcycle
    1: BCategoryVehicle_Fine; //includes Motorcar,Jeep,
    2: CCategoryVehicle_Fine; //includes PrivateCarrier,PublicCarrier
    */
    bool status;
    }

    address public Owner; //adminstrator who manages who can add challan etc.
    mapping(string=>Challan[]) public PreviousChallan; //use to store all previous challans of citizens
    mapping(string=>Challan) public ActiveChallan;  //use to store current active challans of citizen
    mapping(address=>bool) public TP; //mapping for traffic police(TP) , who can add Challan
    VoilationRule[] public RuleList; //list of traffic rules

    constructor(){
        Owner=msg.sender;
    }

////////////////////////////////////////////////////////////////functions related to admin
    function addTrafficPolice(address _TP) public{//add traffic police who can add challans
        require(msg.sender==Owner);
        TP[_TP]=true;
    }

    function addTrafficRule(string calldata _description,uint _Afine,uint _Bfine,uint _Cfine) public{  
        require(msg.sender==Owner);
        RuleList.push(VoilationRule(_description,[_Afine,_Bfine,_Cfine],true));
    }

    function updatePriceForRule(uint _ruleID,uint _Afine,uint _Bfine,uint _Cfine) public{ //update price of rule by giving its rule code 
        require(msg.sender==Owner);
        require(_ruleID<(RuleList.length));
        RuleList[_ruleID].Fine=[_Afine,_Bfine,_Cfine];
    }

    
    function deactivateRule(uint _ruleID) public{
        require(msg.sender==Owner);
        RuleList[_ruleID].status=false;
    }

    function activateRule(uint _ruleID) public{
        require(msg.sender==Owner);
        RuleList[_ruleID].status=true;
    } 

    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    function deleteActiveChallan(string memory _LicenseID) internal { //removes user from active challan
        delete ActiveChallan[_LicenseID];
    }

    function addChallan(string memory _LicenseID,string memory _Name,string memory _CNIC,VehicleType _CarType,string memory _carPlate,uint[] memory _voilatedRules,string memory _timeStamp) public{
        require(TP[msg.sender]==true);
        uint VoilationFee=0;
        for(uint i=0;i<_voilatedRules.length;i++){
            if(_CarType==VehicleType.Motorcycle){
                VoilationFee+=RuleList[i].Fine[0];
            }else if(_CarType==VehicleType.Jeep || _CarType==VehicleType.Motorcar){
                VoilationFee+=RuleList[i].Fine[1];
            }else if(_CarType==VehicleType.PublicServiceVehicle || _CarType==VehicleType.PrivateCarrier || _CarType==VehicleType.PublicCarrier){
                VoilationFee+=RuleList[i].Fine[2];
            }
        }
        ActiveChallan[_LicenseID]=Challan(_LicenseID,_Name,_CNIC,_CarType,_carPlate,_voilatedRules,_timeStamp,VoilationFee,true);
    }

    function test(VehicleType _temp) public pure returns(VehicleType){
        return _temp;
    }

    function getCurrentChallan(string calldata _LicenseID) public view returns(Challan memory){
        return ActiveChallan[_LicenseID];
    }

    // function getChallan(string calldata) public returns(){

    // } 

    // function getChallan(string calldata LicenseID) public{
        
    // }
    

}