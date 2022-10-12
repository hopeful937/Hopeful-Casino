import React, {Component} from 'react'
import {Container, Navbar, Nav, NavDropdown} from 'react-bootstrap'
import logo from '../pictures/arcade-logo.jpg'

class ArcadeNavbar extends Component {
    render () {
        return(
          <Navbar expand="lg" className = 'navbar navbar-dark navbar-static-top shadow' style={{backgroundColor:'#6eb1f5', color:'white'}}>
            <Container>
              <Navbar.Brand href="home">Hopeful Arcade</Navbar.Brand>
              <Navbar.Toggle aria-controls="basic-navbar-nav" />
              <Navbar.Collapse id="basic-navbar-nav">
                <Nav className="me-auto">
                  <Nav.Link href="home">Home</Nav.Link>
                  <Nav.Link href="games/coin">Coin Flipper</Nav.Link>
                  <NavDropdown title="Other Games" id="basic-nav-dropdown">
                    <NavDropdown.Item href="games/rps">Rock Paper Scissors</NavDropdown.Item>
                    <NavDropdown.Item href="games/roadCrosser">Road Crosser</NavDropdown.Item>
                    <NavDropdown.Item href="games/earthDefense">Earth Defense</NavDropdown.Item>
                    <NavDropdown.Divider />
                    <NavDropdown.Item href="donations/Hopeful">Donate with a new idea!</NavDropdown.Item>
                  </NavDropdown>
                </Nav>
                <Nav className='ml-auto'>
                  <Nav.Link href="donations/Hopeful">Support the Dev!</Nav.Link>
                </Nav>
              </Navbar.Collapse>
            </Container>
          </Navbar>
        )
    }
}

export default ArcadeNavbar;