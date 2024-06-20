// Function to verify the claim purpose using ZK pass
    function verifyClaimPurpose(
        address user,
        bytes memory zkProof
    ) internal pure returns (bool) {
        // This function should implement the ZK pass verification logic
        // For simplicity, we'll assume it returns true if zkProof is valid
        // In a real-world scenario, this would involve cryptographic proof verification
        return zkProof.length > 0; // Simplified placeholder logic
    }

    // Function to allow users to make a claim
    function makeClaim(bytes memory zkProof) external {
        require(registeredUsers[msg.sender], "User not registered");
        require(
            block.timestamp >= lastClaimTime[msg.sender] + MATURITY_PERIOD,
            "Claim not matured"
        );
        require(
            verifyClaimPurpose(msg.sender, zkProof),
            "Claim verification failed"
        );
        require(
            address(this).balance >= CLAIM_AMOUNT,
            "Insufficient total payments"
        );

        // Update the last claim time
        lastClaimTime[msg.sender] = block.timestamp;

        // Transfer the claim amount to the user
        payable(msg.sender).transfer(CLAIM_AMOUNT);

        User storage user = users[msg.sender];
        // Add the claim request to the user's claim history
        user.claimHistory.push(
            ClaimHistory(block.timestamp, CLAIM_AMOUNT, "Claim submitted")
        );

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
    function poolBalance() public view returns (uint256) {
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