// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Main{
    enum VehicleType {Motorcycle,Motorcar,Jeep,PublicServiceVehicle,PrivateCarrier,PublicCarrier}

    struct Challan{
    string LicenseID; //license id of citizen
    string CitizenName; 
    string CitizenCNIC;
    VehicleType CarType; 
    string CarNumberPlate;
    uint VoilationCode;
    uint Fine;
    bool status;
    }

    struct VoilationRule{
    string Description; //description of the rule
    uint Fine; 
    bool status;
    }

    address public Owner; //adminstrator who manages who can add challan etc.
    mapping(address=>Challan[]) public PreviousChallan; //use to store all previous challans of citizens
    mapping(address=>Challan) public ActiveChallan;  //use to store current active challans of citizen
    mapping(address=>bool) public TP; //mapping for traffic police(TP) , who can add Challan
    VoilationRule[] public RuleList; //list of traffic rules

    constructor(){
        Owner=msg.sender;
    }

    function addTrafficPolice(address _TP) public{//add traffic police who can add challans
        require(msg.sender==Owner);
        TP[_TP]=true;
    }

    function addTrafficRule(string calldata _description,uint _price) public{  
        require(msg.sender==Owner);
        RuleList.push(VoilationRule(_description,_price,true));
    }

    function updatePriceForRule(uint _ruleID,uint _price) public{ //update price of rule by giving its rule code 
        require(_ruleID<(RuleList.length));
        RuleList[_ruleID].Fine=_price;
    }

    
    function deactivateRule(uint _ruleID) public{
        RuleList[_ruleID].status=false;
    }

    function activateRule(uint _ruleID) public{
        RuleList[_ruleID].status=true;
    } 

    function deleteActiveChallan(address _user) internal { //remooves user from active challan
        delete ActiveChallan[_user];
    }
    // function getChallan(string calldata LicenseID) public{
        
    // }


}