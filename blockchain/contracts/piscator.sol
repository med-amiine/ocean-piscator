pragma solidity ^0.4.17;

/**
 * @title Piscator
 * @author Mohammed El Amine Idmoussi
 */

contract Piscator{
    address[] public deployedChallenges;
    
    function creatChallenge(uint minimum) public{
        address newChallenge = new Pisca(minimum, msg.sender, true);
        deployedChallenges.push(newChallenge);
    }
    
    function getDeployedChallenges() public view returns (address[]){
        return deployedChallenges;
    }
}

contract Pisca {
    
    struct Data {
        string dataName;
        uint value;
        address recipient;
        bool complete;
        uint votersCount;
        uint buyerCount;
        mapping(address => bool) voters;
        mapping(address => bool) data_buyer;
    }

    Data[] public provider;
    address public dataWhale;
    uint public minimumContribution;
    
    
    uint public winnerIndex;
    bool public contractStatus;

    // only the dataWhale can call restricted functions
    modifier restricted() {
        require(msg.sender == dataWhale);
        _;
    }

        /**
    * Constructor function for Pisca
    *
    * @param _minimum The minimum contribution
    * @param _creator The address of the dataWhale
    * @param _status The status of the contract
    */
    
    constructor(uint minimum, address creator, bool status) public {
        dataWhale = creator;
        minimumContribution = minimum;
        contractStatus = status;
    }

    function fund(uint index) public payable {
        Data storage request = provider[index];
        require(!contractStatus == false);
        require (msg.value > minimumContribution);

       request.data_buyer[msg.sender] = true;
       if(msg.sender != dataWhale){
            request.buyerCount++;
       }
    }
    
    /**
   * Add Datas to the Pisca contract.
   * @param dataName the name of the Data
   * @param value the invested value
   * @param recipient the Data provider team address
   * @push Data.
   */
    function createData(string dataName, uint value, address recipient)
    public restricted
    {
     // to add check if a Data address exist already
     
        Data memory newData = Data({
           dataName: dataName,
           value: value,
           recipient: recipient,
           complete: false,
           votersCount: 0,
           buyerCount:0
        });

        provider.push(newData);
    }

    function VoteData(uint index) public {
        Data storage request = provider[index];

        //require(data_buyer[msg.sender]);
        require(!contractStatus == false);
        require(!request.voters[msg.sender]);
        require(!request.complete == true);
        

        request.voters[msg.sender] = true;
        request.votersCount++;
    }

    function getWinner() public restricted {
        require(!contractStatus == false);
         //get the high votersCount Data and send to finalize
        // Data storage request = provider[index]
        uint256 largest = 0; 
        uint256 i;

        for(i = 0; i < provider.length ; i++){
            if(provider[i].votersCount > largest) {
                largest = provider[i].votersCount;
                winnerIndex = i;
            } 
        }
        // this function could be called by the dataWhale if he find a data provider
        finalizeData(winnerIndex);

    }
    
    // after running test and models validation dataWhales can send rest of money
    // remember the quality could be mesure by the accuracy of the models
    function modelValidation(uint index) public restricted{
            Data storage request = provider[index];
            request.recipient.transfer(request.value);
    }
    
    

    function finalizeData(uint index ) public restricted {
        require(!contractStatus == false);
        Data storage request = provider[index];

        //require(request.votersCount > 2));
        require(!request.complete);
        // the data_buyer money is sent to the winner
        request.recipient.transfer(request.value);
        // the prize is sent to the winner
        request.recipient.transfer(address(this).balance);
        request.complete = true;
        contractStatus == false;
        //mark all project as complete function completeAll() or just close the contract
        //add reset all provider code here
        //return winner index
     }

    }
