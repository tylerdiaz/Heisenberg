

# Project Heisenberg

![exampleflow](https://github.com/tylerdiaz/Heisenberg/blob/master/brand-assests/App%20Logo.jpg)

<b>Project Heisenberg</b> is a decentralized identity management system built atop a permissioned Ethereum consortium network.  The goal of this project is to completely eliminate the <i>risk</i> and <i>implict costs</i> associated with pharmacuetical script fraud.

By creating a decentralized smart-contract standard that defines the method for ownership and transferribility of a pharmacuetical script we:
  1. <b>Remove</b> the possibility of counterfit/forged perscriptions is eliminated
  2. <b>Enable</b> regulatory insight into the quantity, concentration, movement, etc. of drugs
  3. <b>Create</b> an <i>immutable</i> record of the movement, quantity, and RX type of pharmacy scripts
  
Project Heisenberg accomplishes this goal through the tokenization of pharmacuetical perscriptions into an ERC-721 solidity contract standar.  This non-fungible token carries metadata describing the doctor ID, the patient's public key, the drug RX Id, and the unit quantity to be dispensed.


## Users, Roles, and Actions

The defined roles for this project scenario are as follows:
  1. <b>Doctor</b>
  2. <b>Patient</b>
  3. <b>Pharmacy</b>
  
  // write a description of each role here
  
 ![Flow](https://github.com/tylerdiaz/Heisenberg/blob/master/brand-assests/Token%20issuance%20and%20prescription%20flow%20chart.png)
 
## Blockchain Network Architecture
<b>Project Heisenberg</b> is hosted on an Ethereum Consortium Network and is permissioned by a custom JSON genesis file.  The network id for peering is 347329323.  For this implementation, we configured five consortim members hosting nodes, with one hosted mining node per member.  We prefunded the addresses with  ether to remove the bottleneck associated with gas scarcity (i.e. DDoS is not a risk in a trusted consortium). 
In full production, the nodes would concievably be owned by pre-authorized public hospitals, regulatory authorites, etc. 

A diagram of the azure-hosted architecture is shown below:

![ConsortiumArchitecture](https://github.com/tylerdiaz/Heisenberg/blob/master/brand-assests/Ethereum%20Consortium%20Architecture.PNG)

## Consortium Rationale
The rationale for choosing a Consortium Network architecture over the Public Mainnet are as follows:

  1. <b>Cost</b> - network actors are able to decouple from the price of ether and avoid the gas fees associated with mainnet transactions
  2. <b>Permissoned Privacy</b> - Only approved entitites are able host a node and gain access the state history of the blockchain.  This provides a choke-point layer of protection which guards the integrity of particpant data from the public, while still allowing regulatory insight, auditability, etc.
  3. <b>Transaction Throughput</b> - a consortium architectural approach allows us to scale independently of mainnet, and avoid the associated TPS bottlenecks, etc.

![exampleflow](https://github.com/tylerdiaz/Heisenberg/blob/master/brand-assests/consortiumRationale.PNG)


## Problems associated with the current paradigm state
To better understand the current perscription paradigm, we consulted with an actal Pharmacist (<i>name witheld</i>) to learn more about security holes, pain-points, and inefficiencies associated with the current system.

<b>What we learned:</b>
  1. <i>There is no authoritative source of truth when it comes to the data layer for pharma perscriptions.</i>  The differences in databases amongst public/private entities creates a systemic risk as it offloads the implicit cost associated with risk to other actors (i.e. the patient and/or doctor). 
  
  2. <i>There exists a quantifiable, implicit cost associated with asymetric moral hazard</i> - because the legal risk of forgery is offloaded to the patient and/or doctor.  This truth is embodied through an anecdote told by 'the Pharmacist',  
  > "Based on how I am personally feeling, my relationship with the doctor, and how truthful I believe the patient is being, I may decide to call the perscribing doctor and verify the perscription."  
  This illustrates the deficiency in <i><b>trust</b></i>, <i><b>verifiability</b></i>, and <i><b>finality</b></i> associated with the current system.
  
  3. <i>Pharmacists face a transmission delay</i>
  
<b>How we created a better system:</b>
  1.  <i>Our solution creates a decentralized, append-only data log where no single keyholder has root-access to the database.</i>  This means that no individual entity has the ability to alter the state history. We have solved the data-layer syncronization problem by creating a triple-entry accounting system where the system's integrity is grounded in both computional infeasability and consortium-level access-control permissions. 
  2.
  3. 
 
## Quantifing the Value of Our Solution
- Quantifying implicit risk of moral hazard

- Moral hazard is the risk that a party to a transaction has not entered into the contract in good faith, has provided misleading information about its assets, liabilities or credit capacity, or has an incentive to take unusual risks in a desperate attempt to earn a profit before the contract settles.  In economics, moral hazard occurs when one person takes more risks because someone else bears the cost of those risks.

## Conclusion

The code for the non-fungible token (ERC-721) is hosted here [link.](link.)
