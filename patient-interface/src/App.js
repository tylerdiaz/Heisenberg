/**
 * web3Context = {
 *   accounts: {Array<string>} - All accounts
 *   selectedAccount: {string} - Default ETH account address (coinbase)
 *   network: {string} - One of 'MAINNET', 'ROPSTEN', or 'UNKNOWN'
 *   networkId: {string} - The network ID (e.g. '1' for main net)
 }
*/

import React, {Component} from 'react';
import PropTypes from 'prop-types';

import 'bootstrap/dist/css/bootstrap.css';
import {
  Media, Table, Button,
  Modal, ModalHeader,
  ModalBody, ModalFooter, Form, FormGroup,
  Label, Input
} from 'reactstrap';
import './App.css';

class ModalForm extends Component {
  constructor(props) {
    super(props);
    this.state = {
      formState: { "dosage-unit": "ml" },
    };
  }

  componentDidMount() {
    const MyContract = window.web3.eth.contract([{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_tokenId","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"approvedFor","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"tokensOf","outputs":[{"name":"","type":"uint256[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"ownerOf","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_doctorToApprove","type":"uint256"}],"name":"approveDoctor","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_pharmacyAddress","type":"address"},{"name":"_tokenId","type":"uint256"}],"name":"fillPrescription","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_tokenId","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"takeOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_patientAddress","type":"address"},{"name":"_doctorId","type":"uint256"},{"name":"_medicationName","type":"string"},{"name":"_brandName","type":"string"},{"name":"_dosage","type":"uint8"},{"name":"_dosageUnit","type":"string"},{"name":"_dateFilled","type":"uint256"},{"name":"_expirationTime","type":"uint256"}],"name":"prescribe","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"inputs":[{"name":"doctorIdsToApprove","type":"uint256[]"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_tokenId","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_approved","type":"address"},{"indexed":false,"name":"_tokenId","type":"uint256"}],"name":"Approval","type":"event"}])

    this.state.ContractInstance = MyContract.at("0x8e75abd182f6e744718ac00c0a14001e5d3ec3a2")
  }

  sendPrescription() {
    debugger;

    this.state.ContractInstance.prescribe(
      this.state.formState["patient-address"],
      1, // hard-coded doctor ID.
      this.state.formState["medication-name"],
      this.state.formState["brand-name"],
      this.state.formState["dosage-quantity"],
      this.state.formState["dosage-unit"],
      this.state.formState["pill-quantity"],
      Date.now(),
      Date.now(this.state.formState["expiration-date"]),
      {
        gas: 300000,
        gasPrice: 400000000000,
        from: this.context.web3.selectedAccount,
        value: 0
      },
      (err, result) => {
        console.log("Err", err);
        console.log("Res", result);
        if (result) { this.props.toggle(); }
      }
    )

    return false;
  }

  inputUpdate(event) {
    this.setState({ formState: { ...this.state.formState, [event.target.name]: event.target.value }})
    return false;
  }

  render () {
    console.log(this.state.formState)
    return (
      <Modal isOpen={this.props.visibility} toggle={this.props.toggle}>
        <ModalHeader toggle={this.props.toggle}>Fill a prescription</ModalHeader>
        <ModalBody>
          <Form>
            <FormGroup>
              <Label for="exampleEmail">Pharmacy wallet address:</Label>
              <Input type="text" name="pharmacy-address" onChange={this.inputUpdate.bind(this)} value={this.state.formState["pharmacy-address"] || ""} placeholder="0x123f681646d4a755815f9cb19e1acc8565a0c2ac" />
            </FormGroup>
          </Form>
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={this.props.toggle}>Cancel</Button>{' '}
          <Button color="primary" onClick={this.sendPrescription.bind(this)}>Fill Prescription</Button>
        </ModalFooter>
      </Modal>
    );
  }
}

ModalForm.contextTypes = {
  web3: PropTypes.object
};

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      modal: false,
      transactionLogs: [
        {
          expiryTime: new Date("3/31/18"),
          prescribedAt: new Date("3/7/18"),
          patientWalletAddress: "0x1a0e14c6c2d16dd42b00b4152645a8b51f2698d6",
          medicationName: "Atorvastatin Calcium",
          brandName: "Lipitor",
          dosage: "120",
          dosageUnit: "mg",
          filled: false
        },
        {
          expiryTime: new Date("2/31/18"),
          prescribedAt: new Date("2/7/18"),
          patientWalletAddress: "0x1a0e14c6c2d16dd42b00b4152645a8b51f2698d6",
          medicationName: "Atorvastatin Calcium",
          brandName: "Lipitor",
          dosage: "120",
          dosageUnit: "mg",
          filled: true
        },
        {
          expiryTime: new Date("1/31/18"),
          prescribedAt: new Date("1/7/18"),
          patientWalletAddress: "0x1a0e14c6c2d16dd42b00b4152645a8b51f2698d6",
          medicationName: "Atorvastatin Calcium",
          brandName: "Lipitor",
          dosage: "120",
          dosageUnit: "mg",
          filled: true
        },
      ]
    }

    this.toggle = this.toggle.bind(this);
  }

  toggle() {
    this.setState({modal: !this.state.modal});
  }

  renderTableRow(tx) {
    return (
      <tr>
        <td>{new Date(tx.expiryTime).toLocaleDateString("en-US")}</td>
        <td>{new Date(tx.prescribedAt).toLocaleDateString("en-US")}</td>
        <td>{tx.dosage}{tx.dosageUnit} of {tx.brandName} ({tx.medicationName})</td>
        <td>
        {tx.filled ? 
          <Button color="default" size="sm" disabled>Prescription filled</Button>:
          <Button color="success" size="sm" onClick={this.toggle}>Fill prescription</Button>
        }
        </td>
      </tr>
    )
  }

  renderPatientDashboard() {

  }

  render() {
    const web3Context = this.context.web3;

    return (
      <div className="App container">
        <strong>Patient Portal</strong>
        <hr />
        <div className="row">
          <div className="col-md-10">
            <Media>
              <Media className="rounded-circle" object src="https://avatars1.githubusercontent.com/u/33433528?s=460&v=4" alt="Generic placeholder image" style={{ marginRight: 15 }} width="100" height="100" />
              <Media body>
                <h1>Hello, Kevin</h1>
                <h4>You've recently been prescribed.</h4>
                <code>{web3Context.selectedAccount}</code>
              </Media>
            </Media>
          </div>
          <div className="col-md-2">
            <br />
          </div>
        </div>
        <br />
        <Table>
          <thead>
            <tr>
              <th>Expires at</th>
              <th>Prescribed at</th>
              <th>Description</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {this.state.transactionLogs.map(this.renderTableRow.bind(this))}
          </tbody>
        </Table>

        <ModalForm visibility={this.state.modal} toggle={this.toggle}/>
      </div>
    );
  }
}

App.contextTypes = {
  web3: PropTypes.object
};
export default App;
