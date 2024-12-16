// src/components/Header.js

import React, { useContext } from 'react';
import { Link } from 'react-router-dom'; // Import Link from react-router-dom
import { Navbar, Nav, Container, Button } from 'react-bootstrap'; // Import necessary Bootstrap components
import { AuthContext } from '../context/AuthContext';

function Header() {
  const { isAuthenticated, logout } = useContext(AuthContext);

  const handleLogout = () => {
    logout();
    localStorage.removeItem('jwtToken');
    window.location.href = '/login';
  };

  return (
    <Navbar bg="light" expand="lg" className="mb-4">
      <Container>
        <Navbar.Brand as={Link} to="/">
          TD TEST PROJECT 
        </Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="ms-auto">
            {!isAuthenticated ? (
              <>
                <Nav.Link as={Link} to="/register">Register</Nav.Link>
                <Nav.Link as={Link} to="/login">Login</Nav.Link>
              </>
            ) : (
              <>
                <Nav.Link as={Link} to="/dashboard">Dashboard</Nav.Link>
                <Nav.Link as={Link} to="/profile">Profile</Nav.Link>
                <Nav.Link as={Link} to="/projects">Projects</Nav.Link>
                <Button variant="outline-secondary" onClick={handleLogout} className="ms-2">
                  Logout
                </Button>
              </>
            )}
          </Nav>
        </Navbar.Collapse>
      </Container>
    </Navbar>
  );
}

export default Header;