// src/pages/Register.js

import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import { Form, Button, Spinner, Alert } from 'react-bootstrap';
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
    setError(null); // Reset error state
    setIsRegistering(true);

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

      const { token } = response.data; // Extract token from response
      localStorage.setItem('jwtToken', token); // Store JWT in localStorage

      toast.success('Registration successful!');
      navigate('/dashboard'); // Redirect to dashboard after successful registration
    } catch (err) {
      console.error('Registration error details:', err.response?.data || err.message);
      const errorMessage = err.response?.data?.error || 'Something went wrong. Please try again.';
      setError(errorMessage);
      toast.error(errorMessage);
    } finally {
      setIsRegistering(false);
    }
  };

  return (
    <>
      <Header />
      <div className="container mt-5">
        <div className="section">
          <h1>Register</h1>
          <Form onSubmit={handleSubmit} className="mt-4">
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
              <Button variant="primary" type="submit" disabled={isRegistering}>
                {isRegistering ? (
                  <>
                    <Spinner
                      as="span"
                      animation="border"
                      size="sm"
                      role="status"
                      aria-hidden="true"
                    /> Registering...
                  </>
                ) : (
                  'Register'
                )}
              </Button>
            </div>
          </Form>
        </div>
      </div>
    </>
  );
}

export default Register;