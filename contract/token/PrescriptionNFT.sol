pragma solidity ^0.4.18;
//pragma experimental ABIEncoderV2;
import "./ERC721.sol";
import "./SafeMath.sol";

/**
 * Notes: 
 * @title PrescrioptionNFT
 * Prescrioption Non-Fungible Token implementation for the required functionality of the ERC721 standard
 *
 */
contract PrescrioptionNFT is ERC721 {
  using SafeMath for uint256;

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
    //payload per pill
    uint8 dosage;
    //Unit for the dosage (mg, `ml, etc)
    string dosageUnit;
    //Number of pills to give in the prescription
    uint8 numPills;
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

  //Total number of token that have been minted
  uint256 private totalTokens;  

  /*
   *  Mappings 
   */
  //Map of the certified doctors Map<tokenId, Prescription>  
  mapping (uint256 => Prescription) private prescriptions;

  //Map of the certified doctors Map<doctorID, Doctor>
  mapping (uint256 => Doctor) private approvedDoctors;
  
  // Mapping from owner to list of owned token IDs
  //May make this a map of maps: Map<address, tokenIds[]>
  mapping (address => uint256[]) private ownedTokens;

  // Mapping from token ID to index of the owner tokens list
  //For prescription x, what is the index in ownedToken
  mapping(uint256 => uint256) private ownedTokensIndex;
 
  /**
   * @dev NFT Constructor
   *    Create a new PrescrioptionNFT with doctors that have already been approved
   *    The contract should be preloaded with gas 
   */
  function PrescrioptionNFT(uint256[] doctorIdsToApprove) public payable {
      // For each of the provided certified doctors,
      // set that doctors credentials to valid
      for (uint i = 0; i < doctorIdsToApprove.length; i++) {
          uint256 doctorToApprove = doctorIdsToApprove[i];
          approvedDoctors[doctorToApprove].doctorId = doctorToApprove;
          approvedDoctors[doctorToApprove].isValid = true;
      }
  }


/*
 * CA methods
 */

  /**
  * @dev Approve a given doctor UUID. This will only be called by the CA
  * @param _doctorToApprove uintuint256 ID of doctor to approve for giving prescriptions
  */
  function approveDoctor(uint256 _doctorToApprove) public payable {
      // set that doctor's credentials to valid
      approvedDoctors[_doctorToApprove].doctorId = _doctorToApprove;
      approvedDoctors[_doctorToApprove].isValid = true;
  }

 /*
 * Doctor methods
 */

  /**
  * @dev Fill the Prescription with the given tokenId. This means that the user will 
  *   transfer their Prescription tokens to the pharmacy address
  * @param _patientAddress wallet address of the patient to recieve the prescription tokens
  * @param _doctorId uint256 ID of doctor to approve for giving prescriptions
  * @param _medicationName medication name
  * @param _brandName medication brand
  * @param _dosage payload per pill
  * @param _dosageUnit unit for payload per pill (mg, ml, etc)
  * @param _numPills number of pills that this token is good for 
  * @param _dateFilled epoch date when the token was minted
  * @param _expirationTime epoch date when the token expires
  */
  function prescribe(
    address _patientAddress, 
    uint256 _doctorId,
    string _medicationName,
    string _brandName,
    uint8 _dosage,
    string _dosageUnit,
    uint8 _numPills,
    uint256 _dateFilled,
    uint256 _expirationTime) public payable doctorIsApproved(_doctorId) {
      //We will start the first tokenId at 0 and essentially treat it as an index
      //the next token id will just be = to the # of tokens 
      uint256 newTokenId = totalTokens;

      //Create a new Prescription token to the chain
      //Add a new Prescription token to the chain
      prescriptions[newTokenId].metadata = PrescriptionMetadata(
        _doctorId,
        _patientAddress,
        _medicationName,
        _brandName,
        _dosage,
        _dosageUnit,
        _numPills,
        _dateFilled,
        _expirationTime
      );

      //numTokens will get incremented in _mint
      //The token will also get created and sent to the patient
      _mint(_patientAddress, newTokenId);
  }

 /*
 * Patient methods
 */

  /**
  * @dev Fill the Prescription with the given tokenId. This means that the user will 
  *   transfer their Prescription tokens to the pharmacy address
  * @param _pharmacyAddress uint256 ID of doctor to approve for giving prescriptions
  * @param _tokenId uint256 ID of Prescription token to send 
  */
  function fillPrescription(address _pharmacyAddress, uint256 _tokenId) public doctorIsApproved(_tokenId) hasNotExpired(_tokenId) {
      transfer(_pharmacyAddress, _tokenId);
  }

  /*
   * Modifiers
   */

  /**
  * @dev Guarantees prescription is not being used after its expiration date
  * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
  */
  modifier hasNotExpired(uint256 _tokenId) {
    require(prescriptions[_tokenId].metadata.expirationTime <= now);
    _;
  }

  /**
  * @dev Guarantees msg.sender is patient who was actually prescribed this token
  * @param _doctorId uint256 ID of the token to validate its ownership belongs to msg.sender
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

  /*
   *  Public Getters
   */

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
  * @dev Transfers the ownership of a given token ID to another address
  * @param _to address to receive the ownership of the given token ID
  * @param _tokenId uint256 ID of the token to be transferred
  */
  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) onlyPrescribedUser(_tokenId) {
    removeTokenAndTransfer(msg.sender, _to, _tokenId);
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
  * @dev Internal function to clear current approval and transfer the ownership of a given token ID
  * @param _from address which you want to send tokens from
  * @param _to address which you want to transfer the token to
  * @param _tokenId uint256 ID of the token to be transferred
  */
  function removeTokenAndTransfer(address _from, address _to, uint256 _tokenId) internal {
    require(_to != address(0));
    require(_to != ownerOf(_tokenId));
    require(ownerOf(_tokenId) == _from);

    removeToken(_from, _tokenId);
    addToken(_to, _tokenId);
    Transfer(_from, _to, _tokenId);
  }

  /**
  * @dev Internal function to add a token ID to the list of a given address
  * @param _to address representing the new owner of the given token ID
  * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
  */
  //add event logger there
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

  //  
  //  @dev no_op these function since approval doesn't meet our use case
  //  
 function approve(address _to, uint256 _tokenId) public{
     //no_op
 }
 
 function takeOwnership(uint256 _tokenId) public{
     //no_op
 }

}
