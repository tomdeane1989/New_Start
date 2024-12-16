// src/pages/Projects.js

import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Link, useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import { Container, Button, Spinner, Card, Row, Col } from 'react-bootstrap';
import Header from '../components/Header';

function Projects() {
  const [projects, setProjects] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem('jwtToken');
    if (!token) {
      toast.warn('You must be logged in to view projects.');
      navigate('/login');
      return;
    }

    axios.get(`${process.env.REACT_APP_API_URL}/projects/user`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then((response) => {
        setProjects(response.data);
        setLoading(false);
      })
      .catch((error) => {
        console.error('Error fetching projects:', error);
        toast.error('Failed to fetch projects');
        setLoading(false);
      });
  }, [navigate]);

  if (loading) {
    return (
      <>
        <Header />
        <Container className="text-center mt-5">
          <Spinner animation="border" role="status">
            <span className="visually-hidden">Loading projects...</span>
          </Spinner>
          <p className="mt-3">Loading projects...</p>
        </Container>
      </>
    );
  }

  return (
    <>
      <Header />
      <Container className="mt-5">
        <div className="d-flex justify-content-between align-items-center mb-4">
          <h1>Your Projects</h1>
          <Button variant="success" onClick={() => navigate('/projects/create')}>
            Create New Project
          </Button>
        </div>
        {projects.length === 0 ? (
          <p>No projects found.</p>
        ) : (
          <Row xs={1} md={2} lg={3} className="g-4">
            {projects.map((proj) => (
              <Col key={proj.project_id}>
                <Card>
                  <Card.Body>
                    <Card.Title>{proj.project_name}</Card.Title>
                    <Card.Text>{proj.description}</Card.Text>
                    <Button as={Link} to={`/projects/${proj.project_id}`} variant="primary">
                      View Details
                    </Button>
                  </Card.Body>
                </Card>
              </Col>
            ))}
          </Row>
        )}
      </Container>
    </>
  );
}

export default Projects;