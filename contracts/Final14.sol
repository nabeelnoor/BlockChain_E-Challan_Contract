// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract ChallanSystem{
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
    uint ACategoryVehicle_Fine;   //includes motorcycle
    uint BCategoryVehicle_Fine;  //includes Motorcar,Jeep,
    uint CCategoryVehicle_Fine; //includes PrivateCarrier,PublicCarrier
    bool status;
    }

    address public Owner; //adminstrator who manages who can add challan etc.
    mapping(string=>Challan[]) public ChallanHistory; //use to store all previous challans of citizens
    mapping(string=>Challan) public ActiveChallan;  //use to store current active challans of citizen
    mapping(address=>bool) public TP; //mapping for traffic police(TP) , who can add Challan
    VoilationRule[] public RuleList; //list of traffic rules

    uint public testValue;
    uint public testStatus;

    constructor(){
        Owner=msg.sender;
        
        RuleList.push(VoilationRule("Exceeding prescribed speed limit",20,50,75,true));
        RuleList.push(VoilationRule("Carrying passengers in a public service vehicle exceeding permissible limit",0,50,75,true));
        RuleList.push(VoilationRule("Violation of traffic signals(Electronic/Manual)",20,50,100,true));
        RuleList.push(VoilationRule("Overloading a goods vehicle",0,50,50,true));
        RuleList.push(VoilationRule("Driving a motor vehicle at night without proper lights",20,30,50,true));
        //append all rules in the start of the application
    }

////////////////////////////////////////////////////////////////functions related to admin
    function addTrafficPolice(address _TP) public{//add traffic police who can add challans
        require(msg.sender==Owner);
        TP[_TP]=true;
    }

    function addTrafficRule(string calldata _description,uint _Afine,uint _Bfine,uint _Cfine) public{  
        require(msg.sender==Owner);
        RuleList.push(VoilationRule(_description,_Afine,_Bfine,_Cfine,true));
    }

    function updatePriceForRule(uint _ruleID,uint _Afine,uint _Bfine,uint _Cfine) public{ //update price of rule by giving its rule code 
        require(msg.sender==Owner);
        require(_ruleID<(RuleList.length));
        RuleList[_ruleID]. ACategoryVehicle_Fine=_Afine;
        RuleList[_ruleID]. BCategoryVehicle_Fine=_Bfine;
        RuleList[_ruleID]. CCategoryVehicle_Fine=_Cfine;
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
        uint length=ChallanHistory[_LicenseID].length;
        ChallanHistory[_LicenseID][length-1].status=false; //change status in its list of challans
        delete ActiveChallan[_LicenseID];
    }

    function addChallan(string memory _LicenseID,string memory _Name,string memory _CNIC,VehicleType _CarType,string memory _carPlate,uint[] memory _voilatedRules,string memory _timeStamp) public{
        // require(TP[msg.sender]==true); //only filled by traffic police officer
        require(ActiveChallan[_LicenseID].status==false);
        uint VoilationFee=0;
        for(uint i=0;i<_voilatedRules.length;i++){
            if(_CarType==VehicleType.Motorcycle){
                VoilationFee+=RuleList[_voilatedRules[i]].ACategoryVehicle_Fine;
            }else if(_CarType==VehicleType.Jeep || _CarType==VehicleType.Motorcar){
                VoilationFee+=RuleList[_voilatedRules[i]].BCategoryVehicle_Fine;
            }else if(_CarType==VehicleType.PublicServiceVehicle || _CarType==VehicleType.PrivateCarrier || _CarType==VehicleType.PublicCarrier){
                VoilationFee+=RuleList[_voilatedRules[i]].CCategoryVehicle_Fine;
            }
        }
        ActiveChallan[_LicenseID]=Challan(_LicenseID,_Name,_CNIC,_CarType,_carPlate,_voilatedRules,_timeStamp,VoilationFee,true);
        ChallanHistory[_LicenseID].push(Challan(_LicenseID,_Name,_CNIC,_CarType,_carPlate,_voilatedRules,_timeStamp,VoilationFee,true));
        
    }


    function getCurrentChallan(string calldata _LicenseID) public view returns(Challan memory){
        return ActiveChallan[_LicenseID];
    }

    function getAllChallan(string calldata _LicenseID) public view returns(Challan[] memory){
        return ChallanHistory[_LicenseID];
    }

    function getTrafficRules() public view returns(VoilationRule[] memory){
        return RuleList;
    }

    function test() public payable returns(uint){
        testValue=msg.value;
        return msg.value;
    }

    function payChallan(string calldata _LicenseID) public payable{
        require(ActiveChallan[_LicenseID].status==true);
        require(msg.value==(ActiveChallan[_LicenseID].Fine*1e18));  //uint tempo=n*1e18;  //equivalent to n ether
        deleteActiveChallan(_LicenseID);
    }
}