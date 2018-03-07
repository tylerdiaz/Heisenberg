# Project Heisenberg

![logo](https://github.com/tylerdiaz/Heisenberg/blob/master/brand-assests/ProjectHeisenberg.PNG)

<b>Project Heisenberg</b> is a decentralized identity management and pharmaceutical ERP system built atop a permissioned Ethereum consortium network.  This project implements a non-fungible token standard to completely eliminate the <i>risk</i> and <i>implicit costs</i> associated with pharmaceutical script fraud.

By creating a decentralized smart-contract standard that defines the method for ownership and transferability of a pharmaceutical script we:
  1. <b>Remove</b> the possibility of counterfeit/forged prescriptions is eliminated
  2. <b>Enable</b> regulatory insight into the quantity, concentration, movement, etc. of drugs
  3. <b>Create</b> an <i>immutable</i> record of the movement, quantity, and RX type of pharmacy scripts
  
Project Heisenberg accomplishes this goal through the tokenization of pharmaceutical prescriptions into an ERC-721 solidity contract standard.  This non-fungible token carries metadata describing the doctor ID, the patient's public key, the drug RX Id, and the unit quantity to be dispensed.


## Users, Roles, and Actions

The defined roles for this project scenario are as follows:
  1. <b>Doctor</b> - Prescribes medication by executing a smart contract which tokenizes a valid prescription, based on metadata such as Doctor ID, Patient Name, Quantity, Dosage, and Expiry Date.
  2. <b>Patient</b> - Receives a token representing a valid prescription issued by a Doctor. Fills a prescription at an authorized Pharmacy by sending token to the Pharmacy's public wallet.
  3. <b>Pharmacy</b> - Disburses medication after receiving token from a Patient, and is payment-agnostic as to receiving token or fiat currency as payment for prescription. Verifies a valid prescription by checking the permission blockchain for a signature between the Patient and Doctor.
    
 ![Flow](https://github.com/tylerdiaz/Heisenberg/blob/master/brand-assests/Token%20issuance%20and%20prescription%20flow%20chart.png)
 
Regulatory bodies with read-only access to the ledger may be considerded to be a "fourth role".  To ensure this, these agents would not host mining nodes or contract-addresses.
 
## Blockchain Network Architecture
<b>Project Heisenberg</b> is hosted on an Ethereum Consortium Network and is permissioned by a custom JSON genesis file.  The network id for peering is 347329323.  For this implementation, we configured five consortium members hosting nodes, with one hosted mining node per member.  We prefunded the addresses with ether to remove the bottleneck associated with gas scarcity (i.e. DDoS is not a risk in a trusted consortium). 

In full production, the nodes would be maintained by entities pre-authorized by an accredited regulatory body - ie.e public hospitals, government agencies, etc. The physical location of these nodes would be irrelevant (i.e. they could be hosted in a cloud environment or on-premise)

A diagram of the azure-hosted architecture is shown below:


![ConsortiumArchitecture](https://github.com/tylerdiaz/Heisenberg/blob/master/brand-assests/Ethereum%20Consortium%20Architecture.PNG)


## Consortium Rationale
The rationale for choosing a Consortium Network architecture over the Public Mainnet are as follows:

  1. <b>Cost</b> - network actors are able to decouple from the price of ether and avoid the gas fees associated with mainnet transactions
  2. <b>Permissioned Privacy</b> - Only approved entities are able host a node and gain access the state history of the blockchain.  This provides a choke-point layer of protection which guards the integrity of participant data from the public, while still allowing regulatory insight, auditability, etc.
  3. <b>Transaction Throughput</b> - a consortium architectural approach allows us to scale independently of mainnet, and avoid the associated TPS bottlenecks, etc.
![exampleflow](https://github.com/tylerdiaz/Heisenberg/blob/master/brand-assests/consortiumRationale.PNG)


## Problems associated with the current paradigm state
To better understand the current prescription paradigm, we consulted with an actual Pharmacist (<i>name withheld</i>) to learn more about security holes, pain-points, and inefficiencies associated with the current system.

### <b>What we learned:</b>
  1. <i>There is no authoritative source of truth when it comes to the data layer for pharma prescriptions.</i>  The differences in databases amongst public/private entities creates a systemic risk as it offloads the implicit cost associated with risk to other actors (i.e. the patient and/or doctor). 


2. <i>There exists a quantifiable, implicit cost associated with asymmetric moral hazard</i> - because the legal risk of forgery is offloaded to the patient and/or doctor.  This truth is embodied through an anecdote told by 'the Pharmacist',  
  > "Based on how I am personally feeling, my relationship with the doctor, and how truthful I believe the patient is being, I may decide to call the prescribing doctor and verify the prescription."  
  
  This illustrates the deficiency in <i><b>trust</b></i>, <i><b>verifiability</b></i>, and <i><b>finality</b></i> associated with the current system.
  
  3. <i>Script verification is a process that can take upwards of 30 minutes to complete.</i> Verifying the authenticity of the script is a manual process which the pharmacist has to do themselves. For example, the pharmacist must pass the log into a database, run an inventory update, wait for manager confirmation, and then fill the prescription.

  
### <b>How we created a better system:</b>
  1.  <i>Our solution creates a decentralized, append-only data log where no single keyholder has root-access to the database.</i>  This means that no individual entity has the ability to alter the state history. We have solved the data-layer synchronization problem by creating a triple-entry accounting system where the system's integrity is grounded in both computational infeasibility and consortium-level access-control permissions. 
  
  2. <i>By leveraging the innate properties of the blockchain, we are able to create an auditable system of script ownership with verifiable ledger history.</i> This allows for increased regulatory insight while also eliminating the base need for trust between doctors, patients, and pharmacists
  
  3. <i>On the blockchain, transaction verification is instant.</i>  In addition, pharmacists receive the assurance of cryptographic transaction finality reached in under 4 blocks (or ~8 minutes)
 
 
## Quantifying the Value of Our Solution

In June 2015 Medicare Strike Force led charges against 243 doctors, nurses, licensed medical professionals, health care company owners and others for allegedly submitting a total of <b>$712 million</b> in fraudulent billings, which was the result of a nationwide sweep — the largest health care fraud takedown in history. More than 40 of the defendants were charged with fraud related to the prescription drug benefit program Medicare Part D. This a classic example of asymmetric risk resulting from <b>moral hazard</b>.

In economics, moral hazard occurs when one person takes more risks because someone else bears the cost of those risks.  

By eliminating moral hazard, or the risk that a party has not entered into the contract in good faith our smart-contract has the potential to eliminate the aforementioned costs associated with fraudulent billing, as well as eliminate explicit costs associated with legal proceedings, supply loss, etc.


## PrescriptionNFT.sol - Under the Hood

The PrescriptionNFT.sol file is a solidity smart-contract which formalizes the tokenization of the pharmaceutical script.  The token takes an input from a doctor, which gets formalized as metadata.  These inputs are:
  1. Doctor ID - which is given to him by the CA, 
  2. Patient Public Key - of the Patient which acts as a verifying mechanism for the pharmacist to prevent dishonest transfer
  3. Medication Name - the name of the pharmaceutical
  4. Brand Name - the specific brand of the pharmaceutical
  5. Dosage - a number representing the pill payload to be dispensed by the pharmacist
  6. Dosage Unit - this will be the formalized measurement unit (i.e mililiters)
  7. Date Filled - the date in which the order was filled by the pharmacist
  8. Total Amount - the total amount of pills to be dispensed by the pharmacist to the patient
  9. Expiration Date - the date in which the prescription expires.  We check against the expiration date when the patient tries to fill the prescription

The code for the non-fungible ERC-721 token, PerscriptionNFT.sol is hosted here [link.](https://github.com/tylerdiaz/Heisenberg/blob/master/contract/token/PrescriptionNFT.sol)


## Conclusion
We are excited to announce that after 24 hours of deep focus and dedication, we are happy to announce that Project Heisenberg is successfully up and running — and available for use for Doctors, Patients, and Pharmacists.

Three separate portals (one for each predefined role) have been developed as a web app for doctors, patients, and pharmacists.  The interface leverages the ReactJS framework and pulls methods from the Web3.JS library to interact with the blockchain through the ABI.  

To access the application, download the [Metamask extension](https://github.com/MetaMask), create an account, and visit the following addresses: 
  * <b>Doctor Portal</b> [Link.](http://34.201.43.128:3000/)
  * <b>Patient Portal</b> [Link.](http://34.201.43.128:3001/)
  

