// src/pages/Profile.js

import React, { useContext, useState, useEffect } from 'react';
import { UserContext } from '../context/UserContext';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { toast } from 'react-toastify';
import { Form, Button, Spinner, Alert, Container, Row, Col, Card } from 'react-bootstrap';
import Header from '../components/Header';

function Profile() {
  const { user, setUser, loading } = useContext(UserContext);
  const [formData, setFormData] = useState({
    username: '',
    email: '',
    first_name: '',
    last_name: '',
  });
  const [isUpdating, setIsUpdating] = useState(false);
  const [error, setError] = useState(null);

  const navigate = useNavigate();

  useEffect(() => {
    if (!loading) {
      const token = localStorage.getItem('jwtToken');
      if (!user) {
        if (!token) {
          toast.warn('You must be logged in to access the profile.');
          navigate('/login');
        }
      } else {
        setFormData({
          username: user.username || '',
          email: user.email || '',
          first_name: user.first_name || '',
          last_name: user.last_name || '',
        });
      }
    }
  }, [user, loading, navigate]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    setIsUpdating(true);
    const token = localStorage.getItem('jwtToken');
    if (!token) {
      toast.warn('No token found. Please log in again.');
      return navigate('/login');
    }

    try {
      const userId = user?.user_id;
      const response = await axios.put(
        `${process.env.REACT_APP_API_URL}/users/${userId}`,
        formData,
        {
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${token}`,
          },
        }
      );

      const updatedUser = response.data.user || response.data;
      setUser(updatedUser);

      toast.success('Profile updated successfully!');
    } catch (err) {
      const errorMessage = err.response?.data?.error || 'Failed to update profile. Please try again.';
      setError(errorMessage);
      toast.error(errorMessage);
    } finally {
      setIsUpdating(false);
    }
  };

  if (loading) {
    return (
      <>
        <Header />
        <Container className="mt-5 text-center">
          <Spinner animation="border" role="status">
            <span className="visually-hidden">Loading...</span>
          </Spinner>
          <p className="mt-3">Loading your profile...</p>
        </Container>
      </>
    );
  }

  if (!user) {
    return null;
  }

  return (
    <>
      <Header />
      <Container className="mt-5">
        <Row className="justify-content-center">
          <Col xs={12} md={8}>
            <Card className="shadow-sm">
              <Card.Body>
                <h1>Your Profile</h1>
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
                    <Button variant="secondary" onClick={() => navigate('/dashboard')} className="me-2">
                      Back to Dashboard
                    </Button>
                    <Button variant="primary" type="submit" disabled={isUpdating}>
                      {isUpdating ? (
                        <>
                          <Spinner
                            as="span"
                            animation="border"
                            size="sm"
                            role="status"
                            aria-hidden="true"
                            className="me-2"
                          /> Saving...
                        </>
                      ) : (
                        'Save Changes'
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

export default Profile;