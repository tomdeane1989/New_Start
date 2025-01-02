// src/pages/CreateProject.js

import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import { Form, Button, Spinner, Alert, Container, Row, Col } from 'react-bootstrap';
import Header from '../components/Header';

function CreateProject() {
  const [projectName, setProjectName] = useState('');
  const [description, setDescription] = useState('');
  const [userRole, setUserRole] = useState('0'); // 0 = Buyer, 1 = Seller
  const [error, setError] = useState(null);
  const [isCreating, setIsCreating] = useState(false);
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null); // Reset error state
    setIsCreating(true);
    const token = localStorage.getItem('jwtToken');
    if (!token) {
      toast.warn('You must be logged in to create a project.');
      return navigate('/login');
    }

    const parsedRole = parseInt(userRole, 10);

    try {
      await axios.post(
        `${process.env.REACT_APP_API_URL}/projects/create`,
        {
          project_name: projectName,
          description,
          user_role: parsedRole,
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
        }
      );
      toast.success('Project created successfully!');
      navigate('/projects');
    } catch (error) {
      console.error('Error creating project:', error);
      const errorMessage = error.response?.data?.error || 'Failed to create project.';
      setError(errorMessage);
      toast.error(errorMessage);
    } finally {
      setIsCreating(false);
    }
  };

  return (
    <>
      <Header />
      <Container className="mt-5">
        <Row className="justify-content-center">
          <Col xs={12} md={8}>
            <div className="form-section">
              <h1>Create a New Project</h1>
              <Form onSubmit={handleSubmit} className="mt-4">
                {error && <Alert variant="danger">{error}</Alert>}

                <Form.Group controlId="projectName" className="mb-3">
                  <Form.Label>Project Name:</Form.Label>
                  <Form.Control
                    type="text"
                    value={projectName}
                    onChange={(e) => setProjectName(e.target.value)}
                    placeholder="Enter the project name"
                    required
                  />
                </Form.Group>

                <Form.Group controlId="description" className="mb-3">
                  <Form.Label>Description (optional):</Form.Label>
                  <Form.Control
                    as="textarea"
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    placeholder="Enter a brief description"
                  />
                </Form.Group>

                <h3>Are you Buying or Selling a house?</h3>
                <Form.Group className="mb-3">
                  <Form.Check
                    type="radio"
                    label="I am Buying (Role = Buyer)"
                    name="user_role"
                    value="0"
                    checked={userRole === '0'}
                    onChange={(e) => setUserRole(e.target.value)}
                  />
                  <Form.Check
                    type="radio"
                    label="I am Selling (Role = Seller)"
                    name="user_role"
                    value="1"
                    checked={userRole === '1'}
                    onChange={(e) => setUserRole(e.target.value)}
                  />
                </Form.Group>

                <div className="d-flex justify-content-end">
                  <Button variant="secondary" onClick={() => navigate('/projects')} className="me-2">
                    Cancel
                  </Button>
                  <Button variant="primary" type="submit" disabled={isCreating}>
                    {isCreating ? (
                      <>
                        <Spinner
                          as="span"
                          animation="border"
                          size="sm"
                          role="status"
                          aria-hidden="true"
                        /> Creating...
                      </>
                    ) : (
                      'Create'
                    )}
                  </Button>
                </div>
              </Form>
            </div>
          </Col>
        </Row>
      </Container>
    </>
  );
}

export default CreateProject;