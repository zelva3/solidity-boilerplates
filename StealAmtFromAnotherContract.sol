// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ReceiveEther {

    // Function to receive Ether. msg.data must be empty.
    receive() external payable {}

    // Fallback function is called when msg.data is not empty.
    fallback() external payable {}

    // This will return the remaining balance of the contract.
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // Withdraw this contracts amount.
    // Provide the address where it has to be withdrawn.
    function withdraw(address _to) public payable{
        // You should restrict who can access this funtion.
        // Especially when you are writting a payable functions.
        // require(msg.sender == owner) like this.
        payable(address(_to)).transfer(address(this).balance);
    }

    // You can use it if you want to display the current sender address.
    function displayAddress() public view returns(address){
        return msg.sender;
    }
}

contract SendEther {

    // Send amount to the ReceiveEther contract.
    function sendViaCall(address payable _to) public payable {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        (bool sent,) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}

// Using interface to make a contact with the deployed contract.
interface With {
    function getBalance() external view returns(uint);
    function withdraw(address _to) external payable;
    function displayAddress() external view returns(address);
}

contract WithrawAmtFromAnotherContract{

    function getBalance(address _address) public view returns(uint){
        return With(_address).getBalance();
    }

    // This will withdraw the amount from another contract which doesn't have owner restriction.
    // Provide the address where it has to be withdrawn.
    function stealAmntFromContract(address _address) public {
        With(_address).withdraw(msg.sender);
    }

    function displayCurrentAddress(address _address) public view returns(address){
        return With(_address).displayAddress();
    }
}