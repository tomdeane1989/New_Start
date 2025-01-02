// src/pages/Register.js

import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import { Form, Button, Spinner, Alert, Container, Row, Col, Card } from 'react-bootstrap';
import Header from '../components/Header';

function Register() {
  const [formData, setFormData] = useState({
    username: '',
    email: '',
    password: '',
    first_name: '',
    last_name: '',
  });

  const [error, setError] = useState(null);
  const [isRegistering, setIsRegistering] = useState(false);
  const navigate = useNavigate();

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setIsRegistering(true);
    const token = localStorage.getItem('jwtToken');
    if (!token) {
      toast.warn('You must be logged in to create a project.');
      navigate('/login');
    }

    try {
      const response = await axios.post(
        `${process.env.REACT_APP_API_URL}/users/create`,
        formData,
        {
          headers: {
            'Content-Type': 'application/json',
          },
        }
      );

      const { token: receivedToken } = response.data;
      localStorage.setItem('jwtToken', receivedToken);

      toast.success('Registration successful!');
      navigate('/dashboard');
    } catch (error) {
      const errorMessage = error.response?.data?.error || 'Something went wrong. Please try again.';
      setError(errorMessage);
      toast.error(errorMessage);
    } finally {
      setIsRegistering(false);
    }
  };

  return (
    <>
      <Header />
      <Container className="mt-5">
        <Row className="justify-content-center">
          <Col xs={12} md={8}>
            <Card className="shadow-sm">
              <Card.Body>
                <h1 className="mb-4">Create Account</h1>
                <Form onSubmit={handleSubmit}>
                  {error && <Alert variant="danger">{error}</Alert>}

                  <Form.Group controlId="username" className="mb-3">
                    <Form.Label>Username:</Form.Label>
                    <Form.Control
                      type="text"
                      name="username"
                      value={formData.username}
                      onChange={handleChange}
                      placeholder="Enter your username"
                      required
                    />
                  </Form.Group>

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

                  <Form.Group controlId="password" className="mb-3">
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

                  <Form.Group controlId="first_name" className="mb-3">
                    <Form.Label>First Name:</Form.Label>
                    <Form.Control
                      type="text"
                      name="first_name"
                      value={formData.first_name}
                      onChange={handleChange}
                      placeholder="Enter your first name"
                    />
                  </Form.Group>

                  <Form.Group controlId="last_name" className="mb-3">
                    <Form.Label>Last Name:</Form.Label>
                    <Form.Control
                      type="text"
                      name="last_name"
                      value={formData.last_name}
                      onChange={handleChange}
                      placeholder="Enter your last name"
                    />
                  </Form.Group>

                  <div className="d-flex justify-content-end">
                    <Button variant="secondary" onClick={() => navigate('/projects')} className="me-2">
                      Cancel
                    </Button>
                    <Button variant="primary" type="submit" disabled={isRegistering}>
                      {isRegistering ? (
                        <>
                          <Spinner
                            as="span"
                            animation="border"
                            size="sm"
                            role="status"
                            aria-hidden="true"
                            className="me-2"
                          /> Registering...
                        </>
                      ) : (
                        'Register'
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

export default Register;