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
import './App.css';

import 'bootstrap/dist/css/bootstrap.css';
import {
  Media, Table, Button, Navbar,
  NavbarBrand, Modal, ModalHeader,
  ModalBody, ModalFooter, Form, FormGroup,
  Label, Input, FormText
} from 'reactstrap';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {modal: false};
    this.toggle = this.toggle.bind(this);
  }

  toggle() {
    this.setState({modal: !this.state.modal});
  }

  render() {
    const web3Context = this.context.web3;

    return (
      <div className="App container">
        <strong>George Washington University Hospital</strong>
        <hr />
        <div className="row">
          <div className="col-md-10">
            <Media>
              <Media className="rounded-circle" object src="https://cdn.ratemds.com/media/doctors/doctor/image/doctor-armin-tehrany-orthopedics-sports_RD4hDWC.jpg_thumbs/v1_at_100x100.jpg" alt="Generic placeholder image" style={{ marginRight: 15 }} width="100" height="100" />
              <Media body>
                <h1>Hello, Dr. Laun</h1>
                <h4>Your recent prescriptions.</h4>
                <code>{web3Context.selectedAccount}</code>
              </Media>
            </Media>
          </div>
          <div className="col-md-2">
            <br />
            <Button color="success" onClick={this.toggle}>Create a prescription</Button>
          </div>
        </div>
        <br />
        <Table>
          <thead>
            <tr>
              <th>Tx Address</th>
              <th>Prescribed to</th>
              <th>Prescribed at</th>
              <th>Description</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th>
                <small>
                  0x000000000000000000000000000003
                </small>
              </th>
              <td>Tyler Diaz</td>
              <td>03/07/2018 @ 12:38am</td>
              <td>10 Coca Colas</td>
              <td>
                <Button color="primary" size="sm">Renew</Button>{' '}
                <Button color="secondary" size="sm">Cancel</Button>
              </td>
            </tr>
            <tr>
              <th>
                <small>
                  0x000000000000000000000000000002
                </small>
              </th>
              <td>Tyler Diaz</td>
              <td>03/07/2018 @ 12:38am</td>
              <td>10 Coca Colas</td>
              <td>
                <Button color="primary" size="sm">Renew</Button>{' '}
                <Button color="secondary" size="sm">Cancel</Button>
              </td>
            </tr>
            <tr>
              <th>
                <small>
                  0x000000000000000000000000000001
                </small>
              </th>
              <td>Tyler Diaz</td>
              <td>03/07/2018 @ 12:38am</td>
              <td>10 Coca Colas</td>
              <td>
                <Button color="primary" size="sm">Renew</Button>{' '}
                <Button color="secondary" size="sm">Cancel</Button>
              </td>
            </tr>
            <tr>
              <th>
                <small>
                  0x000000000000000000000000000000
                </small>
              </th>
              <td>Tyler Diaz</td>
              <td>03/07/2018 @ 12:38am</td>
              <td>10 Coca Colas</td>
              <td>
                <Button color="primary" size="sm">Renew</Button>{' '}
                <Button color="secondary" size="sm">Cancel</Button>
              </td>
            </tr>
            <tr>
              <th>
                <small>
                  0x000000000000000000000000000001
                </small>
              </th>
              <td>Tyler Diaz</td>
              <td>03/07/2018 @ 12:38am</td>
              <td>10 Coca Colas</td>
              <td>
                <Button color="primary" size="sm">Renew</Button>{' '}
                <Button color="secondary" size="sm">Cancel</Button>
              </td>
            </tr>
          </tbody>
        </Table>
        <Modal isOpen={this.state.modal} toggle={this.toggle} className={this.props.className}>
          <ModalHeader toggle={this.toggle}>Create a prescription</ModalHeader>
          <ModalBody>
            <Form>
              <FormGroup>
                <Label for="exampleEmail">Email</Label>
                <Input type="email" name="email" id="exampleEmail" placeholder="with a placeholder" />
              </FormGroup>
              <FormGroup>
                <Label for="exampleSelect">Select</Label>
                <Input type="select" name="select" id="exampleSelect">
                  <option>1</option>
                  <option>2</option>
                  <option>3</option>
                  <option>4</option>
                  <option>5</option>
                </Input>
              </FormGroup>
              <FormGroup>
                <Label for="exampleSelectMulti">Select Multiple</Label>
                <Input type="select" name="selectMulti" id="exampleSelectMulti" multiple>
                  <option>1</option>
                  <option>2</option>
                  <option>3</option>
                  <option>4</option>
                  <option>5</option>
                </Input>
              </FormGroup>

              <div className="card card-body bg-light">
                <FormGroup>
                  <Label for="exampleText">Your Private Key</Label>
                  <Input type="textarea" name="text" id="exampleText" />
                  <FormText color="muted">
                    This is some placeholder block-level help text for the above input.
                    It's a bit lighter and easily wraps to a new line.
                  </FormText>
                </FormGroup>
              </div>
              <FormGroup>
                <Label for="exampleFile">File</Label>
                <Input type="file" name="file" id="exampleFile" />
                <FormText color="muted">
                  This is some placeholder block-level help text for the above input.
                  It's a bit lighter and easily wraps to a new line.
                </FormText>
              </FormGroup>
              <FormGroup tag="fieldset">
                <legend>Radio Buttons</legend>
                <FormGroup check>
                  <Label check>
                    <Input type="radio" name="radio1" />
                    Option one is this and that—be sure to include why it's great
                  </Label>
                </FormGroup>
                <FormGroup check>
                  <Label check>
                    <Input type="radio" name="radio1" />{' '}
                    Option two can be something else and selecting it will deselect option one
                  </Label>
                </FormGroup>
                <FormGroup check disabled>
                  <Label check>
                    <Input type="radio" name="radio1" disabled />{' '}
                    Option three is disabled
                  </Label>
                </FormGroup>
              </FormGroup>
              <FormGroup check>
                <Label check>
                  <Input type="checkbox" />{' '}
                  Check me out
                </Label>
              </FormGroup>
            </Form>
          </ModalBody>
          <ModalFooter>
            <Button color="secondary" onClick={this.toggle}>Cancel</Button>{' '}
            <Button color="primary" onClick={this.toggle}>Send Prescription</Button>
          </ModalFooter>
        </Modal>
      </div>
    );
  }
}

App.contextTypes = {
  web3: PropTypes.object
};
export default App;
