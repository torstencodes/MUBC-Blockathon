pragma solidity >=0.4.21 <0.6.0;

contract IKeyChain {
    
    ///VARIABLES///
    
    mapping(address => uint) roles;
    mapping(address => Employee) employees;
    mapping(address => string) employers;
    mapping(address => mapping(address => bool)) permissions; //employee address, employer address
    
    enum Role {NONE, EMPLOYER, EMPLOYEE, ADMIN}

    struct Employee {
        string name;
        uint jobIndex;
        mapping(uint => Job) jobs;
    }
    
    struct Job {
        address employer;
        string position;
    }
    
    ///MODIFIERS///
    
    modifier onlyAdmin() {
        require(roles[msg.sender] == uint(Role.ADMIN), "Address is not an administrator!");
        _;
    }
    
    modifier onlyEmployee() {
        require(roles[msg.sender] == uint(Role.EMPLOYEE), "Address is not an employee!");
        _;
    }
    
    modifier onlyEmployer() {
        require(roles[msg.sender] == uint(Role.EMPLOYER), "Address is not an employer!");
        _;
    }
    
    modifier onlyVisible(address _employee) {
        require(permissions[_employee][msg.sender], "Address is not permitted to view this record set!");
        _;
    }
    
    ///MUTABLE FUNCTIONS///
    
    /**
     * @dev modifier onlyAdmin
     * Add an employee account to the network
     * @param _employee address the account being enrolled as an employee
     * @param _name string the name of the employee
     **/
    function enrollEmployee(address _employee, string memory _name) public;
    
    /**
     * @dev modifier onlyAdmin
     * Enroll an employer account to the network
     * @param _employer address the account being enrolled as an employer
     * @param _name string the name of the employer
     **/
    function enrollEmployer(address _employer, string memory _name) public;
    
    /**
     * @dev modifier onlyEmployer
     * Add a new job record to an employee's history
     * @param _employee the address of the employee whose record set is being appended
     * @param _position the title associated with the employee's position
     **/
    function addWork(address _employee, string memory _position) public;
    
    /**
     * @dev modifier onlyEmployee
     * Employee enables or disables visibility of record set for a specified employer
     * @param _employer address whose record set visibility is being toggled
     **/
    function toggleVisibility(address _employer) public;
    
    ///VIEWABLE FUNCTIONS///
    
    /**
     * View the role of an account on the network
     * @param _user address the user address being queried for a role
     * @return _role the uint representation of the network role according to the Role enumeration encoding
     **/
    function getRole(address _user) public view returns (uint _role);
    
    /**
     * Return the metadata associated with an employer
     * @param _employer address being queried for metadata
     * @return _name string the name of the employer organization
     **/
    function viewEmployer(address _employer) public view returns (string memory _name);
    
    /**
     * Return the metadata associated with an Employee
     * @param _employee address being queried for metadata
     * @return _name string name of the Employee
     * @return _jobIndex uint index of record set for the employee
     **/
    function viewEmployee(address _employee) public view returns (string memory _name, uint _jobIndex);
    
    /**
     * @dev modifier onlyVisible(_employee)
     * View a specified record from an employee's record set
     * @param _employee address the employee being queried for job data
     * @param _index uint index of record in record set
     * @return _employer address of employer certifying the employment history
     * @return _position string the title associated with the employee's position
     **/
    function viewJob(address _employee, uint _index) public view returns (address _employer, string memory _position);
}