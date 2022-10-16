// SPDX-License-Identifier: MIT
pragma solidity ^0.4.0;

interface Oracle {
    function requestCreatorInfo() external;
    function followersShow () view external returns(uint256);
    function suscribersShow () view external returns(uint256);
    function hourShow () view external returns(uint256);
}

contract CreateProjects {
        struct Contribution {
            uint256 amount;
            uint256 timeUnlock;
            bool used;
        }

        struct Project {
            address owner; 
            Contribution[] contributionList;
            uint256 amountFree;
        }
        mapping(address  => Project) private listNFT;
        address owner;
        uint public balanceTotal;
        address public ownerTotal;
        address public ownerTotal2;
        address public nftTotal;
        address public nftTotal2;
        address oracleAddress;
        Oracle public instanceContract;

        constructor() public {
            owner = msg.sender;
        }

        function addProject(address _addressNFT, address _owner) public {
            require(msg.sender == owner, "Only owner can do that!");
            listNFT[address(_addressNFT)].owner = address(_owner);
            listNFT[address(_addressNFT)].amountFree = 0;
            nftTotal2 = address(_addressNFT);
            ownerTotal2 = listNFT[address(_addressNFT)].owner;
        }

        function addAmount(address _addressNFT) public payable{
            require(msg.value>0, "money is less than 0");
            require(instanceContract.followersShow() > 90 && instanceContract.suscribersShow() > 90 && instanceContract.hourShow() > 40, "Creator very new");
            listNFT[address(_addressNFT)].contributionList.push(Contribution(msg.value, block.timestamp + 20, false));
        }


        function withdraw(address _addressNFT) public {
            require(msg.sender == listNFT[address(_addressNFT)].owner, "Only owner can do that!");
            uint amount = 0;
            for (uint i = 0; i < listNFT[address(_addressNFT)].contributionList.length; i ++){
                if(!listNFT[address(_addressNFT)].contributionList[i].used && block.timestamp < listNFT[address(_addressNFT)].contributionList[i].timeUnlock) {
                    amount = amount + listNFT[address(_addressNFT)].contributionList[i].amount;
                    listNFT[address(_addressNFT)].contributionList[i].used = true;
                }
            }
            listNFT[address(_addressNFT)].amountFree = amount;
            balanceTotal = amount;
            address(this).transfer(amount);
        }

        function setOracle(address _addressOracle) public {
            oracleAddress = _addressOracle;
        }

        function requestWithdraw() public {
            instanceContract = Oracle(oracleAddress);
            instanceContract.requestCreatorInfo();
        }
}