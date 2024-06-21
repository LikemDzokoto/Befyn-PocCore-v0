# Befyn-Core

#### Befyn is health financing and claim  proving insurance protocol. This repo contains Befyn core contracts which enables users to deposit a monthly premium based on an insurance policy, prove the validity of a claims manage the pool of funds staked , calculate the Befyn Insurance claim score of users(Our Cryptoeconomic Incentive Mechanism Design).  
#### For more  depth info , check out our Befyn Product and Dev Docs  [here](https://github.com/likemdzokoto/Befyn-Docs)








## Contract  Deployment Address

### Sepolia 

| Contract Name            | Addresses                                  |
| ------------------------ | ------------------------------------------ |
| BefynInsurance Contract  | 0x6777B22b55286025A5a48d970772811AC3bAD1a3 |




## Smart Contract Component

### BefynInsurance.sol
BefynInsurance Contract an  insurance contract where users can register, make premium payments, and submit claims. 

-Here's a breakdown of the contract's functionality:

-Registration: Users can register using the register() function, which sets a flag in the registered Users mapping.
- Premium Payments: Users can make premium payments using the premiumA() and premiumB() functions, which add the payment to the user's payment history and update their total amount paid.
- Claim Submission: Users can submit a claim using the makeClaim() function, which verifies the claim purpose using a ZK pass (simplified logic for demonstration purposes), checks if the user is registered and if the claim is matured, and transfers the claim amount to the user.
- Claim History: Users can get their claim history using the getClaimRequests() function.
- Payment History: Users can get their payment history using the getPaymentHistory() function.
- Contract Balance: The contract balance can be checked using the poolBalance() function.
- Events: The contract emits events for user registration, premium payments, claim submission, and claim payment.



## Functions:

- register(): Allows a user to register.
- premiumA() and premiumB(): Allow users to make premium payments.
- getPaymentHistory(): Returns a user's payment history.
- verifyClaimPurpose(): Verifies the claim purpose using a ZK pass (simplified logic for demonstration purposes).
- makeClaim(): Allows users to make a claim.
- getClaimRequests(): Returns a user's claim requests.
- poolBalance(): Returns the contract's balance.
- receive() and fallback(): Fallback functions to receive Ether (currently set to call premiumA()).



## Structs

- User: Stores information about a user's payments and claims.
- PaymentHistory and ClaimHistory: Store information about a user's payments and claims respectively.


## Events

- UserPaymentEvent: Emitted when a user makes a premium payment.
- UserClaimEvent: Emitted when a user submits a claim request.
- UserRegistered: Emitted when a user registers.
- ClaimMade and ClaimPaid: Emitted when a claim is made and paid respectively.
- PoolUpdateEvent: Emitted when the contract's balance is updated.






To setup project, you need to:

Clone the repository:

```bash
git clone https://github.com/likemdzokoto/Befyn-Core
cd Befyn-Core
```

- ` npm install`

-  `npx hardhat compile` 

- `npx hardhat run scripts/deploy_befyninsurance.ts --network sepoliaTestnet `

## Configuration

### Configure Environment Variables

Create a `.env` file with the variables stated in the `.env.sample` file

- `PRIVATE_KEY`: Private key of your Ethereum account (from Metamask).
- `SEPOLIA_RPC_URL`: URL of the Sepolia testnet node.
- `ETHERSCAN_KEY`: Etherscan Api key  for verfiying contracts

