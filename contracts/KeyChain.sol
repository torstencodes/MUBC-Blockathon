pragma solidity >=0.4.21 <0.6.0;

import './IKeyChain.sol';

/**
 * Implentation of KeyChain Smart Contract
 * @author Blockathon Team Lego
 * Date: 11/16/2019
 **/
contract KeyChain is IKeyChain {

    function enrollEmployee(address _employee, string memory _name) public onlyAdmin() {
        require(roles[_employee] == uint(Role.NONE), "Address is already enrolled in the network!");
        employees[_employee].name = _name;
    }

    function enrollEmployer(address _employer, string memory _name) public onlyAdmin() {
        require(roles[_employer] == uint(Role.NONE), "Address is already enrolled in the network!");
        employers[_employer] = _name;
    }

    function addWork(address _employee, string memory _position) public onlyEmployer() {
        uint index = employees[_employee].jobIndex++;
        employees[_employee].jobs[index].employer = msg.sender;
        employees[_employee].jobs[index].position = _position;
    }

    function toggleVisibility(address _employer) public onlyEmployee() {
        permissions[msg.sender][_employer] = !(permissions[msg.sender][_employer]);
    }

    function getRole(address _user) public view returns (uint _role) {
        return roles[_user];
    }

    function viewEmployer(address _employer) public view returns (string memory _name) {
        require(roles[_employer] == uint(Role.EMPLOYER), "Cannot view address who is not employer!");
        return employers[_employer];
    }

    function viewEmployee(address _employee) public view returns (string memory _name, uint _jobIndex) {
        require(roles[_employee] == uint(Role.EMPLOYEE), "Cannot view address who is not employee");
        _name = employees[_employee].name;
        _jobIndex = employees[_employee].jobIndex;
    }

    function viewJob(address _employee, uint _index) public onlyVisible(_employee) view returns (address _employer, string memory _position) {
        require(_index <= employees[_employee].jobIndex, "Job index is out of bounds!");
        _employer = employees[_employee].jobs[_index].employer;
        _position = employees[_employee].jobs[_index].position;
    }
}