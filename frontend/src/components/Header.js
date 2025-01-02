// src/components/Header.js
import React, { useContext } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Navbar, Nav, Container, Button } from 'react-bootstrap';
import { AuthContext } from '../context/AuthContext';

function Header() {
  const { isAuthenticated, logout } = useContext(AuthContext);
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <Navbar bg="primary" variant="dark" expand="lg" className="shadow-sm">
      <Container>
        <Navbar.Brand as={Link} to="/">
          <img
            src="/logo.png"
            alt="Project Logo"
            height="30"
            className="d-inline-block align-top me-2"
          />
          TD TEST PROJECT
        </Navbar.Brand>
        <Navbar.Toggle aria-controls="navbar-nav" />
        <Navbar.Collapse id="navbar-nav">
          <Nav className="ms-auto">
            {!isAuthenticated ? (
              <>
                <Nav.Link as={Link} to="/register" className="me-3">
                  Register
                </Nav.Link>
                <Nav.Link as={Link} to="/login">
                  Login
                </Nav.Link>
              </>
            ) : (
              <>
                <Nav.Link as={Link} to="/dashboard" className="me-3">
                  Dashboard
                </Nav.Link>
                <Nav.Link as={Link} to="/profile" className="me-3">
                  Profile
                </Nav.Link>
                <Nav.Link as={Link} to="/projects" className="me-3">
                  Projects
                </Nav.Link>
                {/* New link to Documents */}
                <Nav.Link as={Link} to="/documents" className="me-3">
                  Documents
                </Nav.Link>

                <Button variant="outline-light" onClick={handleLogout}>
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