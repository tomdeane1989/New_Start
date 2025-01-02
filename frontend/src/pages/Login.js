// src/pages/Login.js

import React, { useState, useContext } from 'react';
import { useNavigate, Navigate } from 'react-router-dom';
import axios from 'axios';
import { toast } from 'react-toastify';
import { Form, Button, Spinner, Alert, Container, Row, Col, Card } from 'react-bootstrap';
import { AuthContext } from '../context/AuthContext';
import Header from '../components/Header';

function Login() {
  const { isAuthenticated, login } = useContext(AuthContext);
  const [formData, setFormData] = useState({ email: '', password: '' });
  const [error, setError] = useState(null);
  const [isLoggingIn, setIsLoggingIn] = useState(false);
  const navigate = useNavigate();

  if (isAuthenticated) {
    return <Navigate to="/dashboard" replace />;
  }

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setIsLoggingIn(true);

    try {
      const response = await axios.post(
        `${process.env.REACT_APP_API_URL}/auth/login`,
        formData,
        { headers: { 'Content-Type': 'application/json' } }
      );

      const { token } = response.data;
      login(token);
      toast.success('Login successful!');
      navigate('/dashboard');
    } catch (err) {
      const errorMessage = err.response?.data?.error || 'Invalid login credentials';
      setError(errorMessage);
      toast.error(errorMessage);
    } finally {
      setIsLoggingIn(false);
    }
  };

  return (
    <>
      <Header />
      <Container className="mt-5">
        <Row className="justify-content-center">
          <Col xs={12} md={6}>
            <Card className="shadow-sm">
              <Card.Body>
                <h2 className="text-center mb-4">Login</h2>
                <Form onSubmit={handleSubmit}>
                  {error && <Alert variant="danger">{error}</Alert>}
                  <Form.Group controlId="email" className="mb-3">
                    <Form.Label>Email:</Form.Label>
                    <Form.Control
                      type="email"
                      name="email"
                      value={formData.email}
                      onChange={handleChange}
                      placeholder="Enter your email"
                      required
                    />
                  </Form.Group>
                  <Form.Group controlId="password" className="mb-4">
                    <Form.Label>Password:</Form.Label>
                    <Form.Control
                      type="password"
                      name="password"
                      value={formData.password}
                      onChange={handleChange}
                      placeholder="Enter your password"
                      required
                    />
                  </Form.Group>
                  <div className="d-flex justify-content-end">
                    <Button variant="primary" type="submit" disabled={isLoggingIn}>
                      {isLoggingIn ? (
                        <>
                          <Spinner
                            as="span"
                            animation="border"
                            size="sm"
                            role="status"
                            aria-hidden="true"
                            className="me-2"
                          /> Logging in...
                        </>
                      ) : (
                        'Login'
                      )}
                    </Button>
                  </div>
                </Form>
              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    </>
  );
}

export default Login;