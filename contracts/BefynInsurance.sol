// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract  BefynContract {

    address public immutable i_OWNER;

    constructor() {
       i_OWNER = msg.sender;
    }

    // Premium contribution amounts in wei
    uint256 public constant PREMUIM_A = 0.01 ether; // 0.01 ETH
    uint256 public constant PREMUIM_B = 0.02 ether; // 0.02 ETH
    
    uint256 public constant CLAIM_AMOUNT = 0.1 ether; // 0.1 ETH
    uint256 public constant MATURITY_PERIOD = 365 days;

 
    // Mapping of user addresses to user structs
    mapping (address => User) public users;

    // Mapping to track registered users
    mapping(address => bool) public registeredUsers;

     // Mapping to track user claims
    mapping(address => uint256) public lastClaimTime;


    // Struct to store user information
    struct User {
        uint256 totalamount;
        PaymentHistory[] paymentHistory;
        ClaimHistory[] claimHistory;
    }

    // Struct to store claim history
    struct ClaimHistory {
        uint256 claimDate;
        uint256 claimAmount;
        string claimEvent;
    }


    // Struct to store payment history
    struct PaymentHistory {
        uint256 paymentDate;
        uint256 paymentAmount;
        string paymentEvent;
    }

    // Event emitted when a user makes a premium payment
    event UserPaymentEvent(address userAddress, uint paymentDate, uint paymentAmount);

    // Event emitted when a user submits a claim request
    event UserClaimEvent(address userAddress, uint claimDate, uint claimAmount);

    // Event to log user registration
    event UserRegistered(address indexed user);

    // Event to log claims
    event ClaimMade(address indexed user, uint256 claimTime);
    event ClaimPaid(address indexed user, uint256 amount, uint256 paymentTime);

    event PoolUpdateEvent(uint poolBalance, uint eventDate, uint eventAmount);


    // Function for users to register
    function register() external {
        require(!registeredUsers[msg.sender], "User already registered");

        // Register the user
        registeredUsers[msg.sender] = true;

        // Emit the registration event
        emit UserRegistered(msg.sender);
    }

    // Function to pay contribution
    function premiumA() public payable _checkRegister(){
        require( msg.value == PREMUIM_A, "Enter 0.01 ETH premium amount");
        // Get the user struct from the mapping
        User storage user = users[msg.sender];
        // Add the payment to the user's payment history
        user.paymentHistory.push(PaymentHistory(block.timestamp, msg.value, "Payment payment made"));
        user.totalamount += msg.value;
 
        // Emit the UserPaymentEvent
        emit UserPaymentEvent(msg.sender, block.timestamp, msg.value);

    }

    // Function to pay contribution
    function premiumB() public payable _checkRegister(){
        require( msg.value == PREMUIM_B, "Enter 0.02 ETH premium amount");
        // Get the user struct from the mapping
        User storage user = users[msg.sender];
        // Add the payment to the user's payment history
        user.paymentHistory.push(PaymentHistory(block.timestamp, msg.value, "Payment payment made"));
        user.totalamount += msg.value;

        // Emit the UserPaymentEvent
        emit UserPaymentEvent(msg.sender, block.timestamp, msg.value);

    }


    // Function to get a user's payment history
    function getPaymentHistory() public view returns (PaymentHistory[] memory) {
        // Get the user struct from the mapping
        User storage user = users[msg.sender];
        return user.paymentHistory;
    }

    // Function to verify the claim purpose using ZK pass
    function verifyClaimPurpose(address, bytes memory zkProof) internal pure returns (bool) {
        // This function should implement the ZK pass verification logic
        // For simplicity, we'll assume it returns true if zkProof is valid
        // In a real-world scenario, this would involve cryptographic proof verification
        return zkProof.length > 0; // Simplified placeholder logic
    }

   
    // Function to allow users to make a claim
    function makeClaim(bytes memory zkProof) external {
        require(registeredUsers[msg.sender], "User not registered");
        require(block.timestamp >= lastClaimTime[msg.sender] + MATURITY_PERIOD, "Claim not matured");
        require(verifyClaimPurpose(msg.sender, zkProof), "Claim verification failed");
        require(address(this).balance >= CLAIM_AMOUNT, "Insufficient total payments");

        // Update the last claim time
        lastClaimTime[msg.sender] = block.timestamp;

        // Transfer the claim amount to the user
        payable(msg.sender).transfer(CLAIM_AMOUNT);

        User storage user = users[msg.sender];
        // Add the claim request to the user's claim history
        user.claimHistory.push(ClaimHistory(block.timestamp, CLAIM_AMOUNT, "Claim submitted"));

        // Emit the claim made event
        emit ClaimMade(msg.sender, block.timestamp);
        // Emit the claim paid event
        emit ClaimPaid(msg.sender, CLAIM_AMOUNT, block.timestamp);
    }


    // Function to get a user's claim requests
    function getClaimRequests() public view returns (ClaimHistory[] memory) {
        // Get the user struct from the mapping
        User storage user = users[msg.sender];
        return user.claimHistory;
    }

    
    // check contract balance
    function poolBalance() public view returns(uint256) {
        return address(this).balance;
    }

    // Fallback function to receive Ether
    receive() external payable {
        premiumA();
    }

        // Fallback function to receive Ether
    fallback() external payable {
        premiumA();
    }

    modifier _checkRegister() {
        require(registeredUsers[msg.sender], "User not registered");
        _;
    }
}