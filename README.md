# Project Heisenberg
Solving prescription/pharmaceutical logistics using smart contracts

[title](https://www.exampleUserFlow.jpg)

Project Heisenberg is a decentralized identity management system built atop a permissioned Ethereum consortium network.  The goal of this project is to completely eliminate the possibility of perscription fraud.

By creating a decentralized smart-contract standard that defines the method for ownership and transferribility of a perscription we have solved a variety of problems.
  1. The possibility of counterfit/forged perscriptions is eliminated
  2. An immutable record of the movement, quantity, identity, etc. of perscriptions is created
  3. The possibilty for regulatory insight into the quantity, concentration, movement, etc. of drugs is enabled
  4. Communication and trust between doctors, patients, and pharmaceys is improved
  
Project Heisenberg accomplishes this goal through the tokenization of pharmacuetical perscriptions into an ERC-721 solidity contract standar.  This non-fungible token carries metadata describing the doctor ID, the patient's public key, the drug RX Id, and the unit quantity to be dispensed.

The defined roles for this project scenario are as follows:
  1. Doctor
  2. Patient
  3. Pharmacy
  
 [role description here]
 
## System Architecture
Project Heisenberg is hosted on an Ethereum Consortium Network and is permissioned by a custom JSON file.  For this implementation, we configured five consortim members hosting nodes, with one hosted mining node per member.  In production, these nodes could be owned by pre-authorized hospitals, regulatory authorites, private medical practices, etc.  A diagram of the azure-hosted architecture is below.

[Image](link.)

The rationale for choosing a Consortium Network architecture over the Public Mainnet are as follows:
  1. <b>Cost</b>
  2. <b>Permissoned Privacy</b>
  3. <b>Transaction Throughput</b>

The code for the non-fungible script is hosted here (link.). 
 
 ## Real World Scenario Description

I. Current State scenario description/visual
  - 
II. Tokenized State scenario description/visual
 
## Business Value Proposition
 
## Quantified Business Value / Conclusion
