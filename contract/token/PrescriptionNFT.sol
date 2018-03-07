pragma solidity ^0.4.18;

import "./ERC721.sol";
import "../math/SafeMath.sol";

/**
 * Notes: 
 Were not touching _mint() --> assuming that the doctor already has X from the CA

   //prunnpm install -g solcing old/dead data
    // if the Etherum block cahin can have all of the data, our consortium will have the rest
  //tokens per patient per perscription?

  //How to limit write and reads from the chain
    //mutable tokens?

  //Pharmacy 
  //Doctor registraton base

  //Concerns around persoanlly identifiable information 
  //sign the presciption creation with both the patient and the doctor?
  //Dont have to encrpty the payload since its on a consortium

  //Opt in system

  //Dont need totalTokens since they are infinite
  //Could keep it for auditing?
  //Or rather just tokensPerDoctor
    uint256 private totalTokens;

  //Call up pharmacy and ask for pain points 
    //Why?
 * @title PrescrioptionNFT
 * Generic implementation for the required functionality of the ERC721 standard
 *
 * address(0) is a newly created contract's address, which literally translates to 0x0
 */
contract PrescrioptionNFT is ERC721 {
  using SafeMath for uint256;

  //Total number of token that have been minted
  uint256 private totalTokens;  

  struct PrescriptionMetadata {
    //Doctor ID that sent this prescription
    //This is the ID that is given to verified doctors by the CA
    uint256 doctorId;
    //Doctor ID that sent this prescription
    //This is the ID that is given to verified doctors by the CA
    address prescribedPatient;
    //Scientific name of the medicine
    string medicationName;
    //Brand name of the medicine
    string brandName;
    //Amount to five the patient
    uint8 dosage;
    //Unit for the dosage (mg, ml, etc)
    string dosageUnit;
    //Epoch time when the preciption was given (mint time)
    uint256 dateFilled;
    //Epoch expiration date (When is this prescription no longer valid)
    uint256 expirationTime;
  }

  struct Prescription {
    PrescriptionMetadata metadata;
    address owner;
  }

  //unfortuantely there's no real great Set<> in solidity (that I've found)
  //So we'll just create a struct to replicate this
  struct Doctor {
    //This is the uuid assigned to the verified doctor by the CA
    uint256 doctorId;
    bool isValid;
  }

  //Map of the certified doctors Map<tokenId, Prescription>  
  mapping (uint256 => Prescription) private prescriptions;

  //Map of the certified doctors Map<doctorUUID, Doctor>
  mapping (uint256 => Doctor) private approvedDoctors;

  //For date time chainStartTime = now;
  //Map for tokenId to prescription metadata
  // mapping (uint256 => PrescriptionMetadata) private userToPrescription;
  // // Map<tokenId, PrescriptionMetadata>()
  // // metadata[_tokenID].type 
  
  // // Mapping from token ID to owner
  // mapping (uint256 => address) private tokenOwner;

  // Mapping from token ID to approved address
  //You can only send this to certain addresses
  mapping (uint256 => address) private tokenApprovals;


  // Mapping from owner to list of owned token IDs
  mapping (address => uint256[]) private ownedTokens;
  //May make this a map of maps: Map<address, Map<>>
  // mapping (address => mapping(uint256 => uint256)) private ownedTokens;

  // Mapping from token ID to index of the owner tokens list
  //For prescription x, what is the index in ownedToken
  mapping(uint256 => uint256) private ownedTokensIndex;

  //constructor 
  /**
   * @dev Create a new PrescrioptionNFT with certain doctors pre approved
   *      doctorIdsToApprove can be empty
   */
  function PrescrioptionNFT(uint8[] doctorIdsToApprove) public {
        // For each of the provided certified doctors,
        // set that doctors credentials to valid
        for (uint i = 0; i < doctorIdsToApprove.length; i++) {
            // `Proposal({...})` creates a temporary
            // Proposal object and `proposals.push(...)`
            // appends it to the end of `proposals`.
            uint256 doctorToApprove = doctorIdsToApprove[i];
            approvedDoctors[doctorToApprove].doctorId = doctorToApprove;
            approvedDoctors[doctorToApprove].isValid = true;
        }
    }


  /**
  * @dev Guarantees msg.sender is patient who was actually prescribed this token
  * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
  */
  modifier doctorIsApproved(uint256 _doctorId) {
    require(approvedDoctors[_doctorId].isValid);
    _;
  }

  /**
  * @dev Guarantees msg.sender is patient who was actually prescribed this token
  * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
  */
  modifier onlyPrescribedUser(uint256 _tokenId) {
    require(prescriptions[_tokenId].metadata.prescribedPatient == msg.sender);
    _;
  }

  /**
  * @dev Guarantees msg.sender is owner of the given token
  * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
  */
  modifier onlyOwnerOf(uint256 _tokenId) {
    require(ownerOf(_tokenId) == msg.sender);
    _;
  }

  /**
  * @dev Gets the total amount of tokens stored by the contract
  * @return uint256 representing the total amount of tokens
  */
  function totalSupply() public view returns (uint256) {
    return totalTokens;
  }

  /**
  * @dev Gets the balance of the specified address
  * @param _owner address to query the balance of
  * @return uint256 representing the amount owned by the passed address
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return ownedTokens[_owner].length;
  }


  /**
  * @dev Gets the list of tokens owned by a given address
  * @param _owner address to query the tokens of
  * @return uint256[] representing the list of tokens owned by the passed address
  */
  function tokensOf(address _owner) public view returns (uint256[]) {
    return ownedTokens[_owner];
  }

  /**
  * @dev Gets the owner of the specified token ID
  * @param _tokenId uint256 ID of the token to query the owner of
  * @return owner address currently marked as the owner of the given token ID
  */
  function ownerOf(uint256 _tokenId) public view returns (address) {
    address owner = prescriptions[_tokenId].owner;
    require(owner != address(0));
    return owner;
  }

  /**
   * @dev Gets the approved address to take ownership of a given token ID
   * @param _tokenId uint256 ID of the token to query the approval of
   * @return address currently approved to take ownership of the given token ID
   */
  function approvedFor(uint256 _tokenId) public view returns (address) {
    return tokenApprovals[_tokenId];
  }

  /**
  * @dev Transfers the ownership of a given token ID to another address
  * @param _to address to receive the ownership of the given token ID
  * @param _tokenId uint256 ID of the token to be transferred
  */
  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) onlyPrescribedUser(_tokenId) {
    clearApprovalAndTransfer(msg.sender, _to, _tokenId);
  }

  /**
  * @dev Approves another address to claim for the ownership of the given token ID
  * @param _to address to be approved for the given token ID
  * @param _tokenId uint256 ID of the token to be approved
  */
  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) onlyPrescribedUser(_tokenId) {
    address owner = ownerOf(_tokenId);
    require(_to != owner);
    if (approvedFor(_tokenId) != 0 || _to != 0) {
      tokenApprovals[_tokenId] = _to;
      Approval(owner, _to, _tokenId);
    }
  }

  /**
  * @dev Claims the ownership of a given token ID
  * @param _tokenId uint256 ID of the token being claimed by the msg.sender
  */
  function takeOwnership(uint256 _tokenId) public {
    require(isApprovedFor(msg.sender, _tokenId));
    clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
  }

  /**
  * @dev Mint token function
  * @param _to The address that will own the minted token
  * @param _tokenId uint256 ID of the token to be minted by the msg.sender
  */
  function _mint(address _to, uint256 _tokenId) internal {
    require(_to != address(0));
    addToken(_to, _tokenId);
    Transfer(0x0, _to, _tokenId);
  }

  /**
  * @dev Burns a specific token
  * @param _tokenId uint256 ID of the token being burned by the msg.sender
  */
  function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
    if (approvedFor(_tokenId) != 0) {
      clearApproval(msg.sender, _tokenId);
    }
    removeToken(msg.sender, _tokenId);
    Transfer(msg.sender, 0x0, _tokenId);
  }

  /**
   * @dev Tells whether the msg.sender is approved for the given token ID or not
   * This function is not private so it can be extended in further implementations like the operatable ERC721
   * @param _owner address of the owner to query the approval of
   * @param _tokenId uint256 ID of the token to query the approval of
   * @return bool whether the msg.sender is approved for the given token ID or not
   */
  function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
    return approvedFor(_tokenId) == _owner;
  }

  /**
  * @dev Internal function to clear current approval and transfer the ownership of a given token ID
  * @param _from address which you want to send tokens from
  * @param _to address which you want to transfer the token to
  * @param _tokenId uint256 ID of the token to be transferred
  */
  function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
    require(_to != address(0));
    require(_to != ownerOf(_tokenId));
    require(ownerOf(_tokenId) == _from);

    clearApproval(_from, _tokenId);
    removeToken(_from, _tokenId);
    addToken(_to, _tokenId);

    Transfer(_from, _to, _tokenId);
  }



  /**
  * @dev Internal function to clear current approval of a given token ID
  * @param _tokenId uint256 ID of the token to be transferred
  */
  function clearApproval(address _owner, uint256 _tokenId) private {
    require(ownerOf(_tokenId) == _owner);
    tokenApprovals[_tokenId] = 0;
    Approval(_owner, 0, _tokenId);
  }

  /**
  * @dev Internal function to add a token ID to the list of a given address
  * @param _to address representing the new owner of the given token ID
  * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
  */
  function addToken(address _to, uint256 _tokenId) private {
    require(prescriptions[_tokenId].owner == address(0));
    prescriptions[_tokenId].owner = _to;
    uint256 length = balanceOf(_to);
    ownedTokens[_to].push(_tokenId);
    ownedTokensIndex[_tokenId] = length;
    totalTokens = totalTokens.add(1);
  }

  /**
  * @dev Internal function to remove a token ID from the list of a given address
  * @param _from address representing the previous owner of the given token ID
  * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
  */
  function removeToken(address _from, uint256 _tokenId) private {
    require(ownerOf(_tokenId) == _from);

    uint256 tokenIndex = ownedTokensIndex[_tokenId];
    uint256 lastTokenIndex = balanceOf(_from).sub(1);
    uint256 lastToken = ownedTokens[_from][lastTokenIndex];

    prescriptions[_tokenId].owner = 0;
    ownedTokens[_from][tokenIndex] = lastToken;
    ownedTokens[_from][lastTokenIndex] = 0;

    // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
    // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
    // the lastToken to the first position, and then dropping the element placed in the last position of the list
    ownedTokens[_from].length--;
    ownedTokensIndex[_tokenId] = 0;
    ownedTokensIndex[lastToken] = tokenIndex;
    totalTokens = totalTokens.sub(1);
  }

}
