// src/pages/Dashboard.js

import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { toast } from 'react-toastify';
import { Container, Row, Col, Card, Button, Spinner } from 'react-bootstrap';
import Header from '../components/Header';

function Dashboard() {
  const [projects, setProjects] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    fetchProjects();
  }, []);

  const fetchProjects = async () => {
    const token = localStorage.getItem('jwtToken');
    if (!token) {
      toast.warn('You must be logged in to access the dashboard.');
      navigate('/login');
      return;
    }

    try {
      const response = await axios.get(`${process.env.REACT_APP_API_URL}/projects/user`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setProjects(response.data);
      setLoading(false);
    } catch (error) {
      console.error('Error fetching projects:', error);
      toast.error('Failed to fetch projects.');
      setLoading(false);
    }
  };

  const deleteProject = async (projectId) => {
    const token = localStorage.getItem('jwtToken');
    if (window.confirm('Are you sure you want to delete this project?')) {
      try {
        await axios.delete(`${process.env.REACT_APP_API_URL}/projects/${projectId}`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        toast.success('Project deleted successfully!');
        fetchProjects(); // Refresh the project list after deletion
      } catch (error) {
        console.error('Error deleting project:', error);
        toast.error('Failed to delete project.');
      }
    }
  };

  if (loading) {
    return (
      <>
        <Header />
        <Container className="text-center mt-5">
          <Spinner animation="border" role="status">
            <span className="visually-hidden">Loading your dashboard...</span>
          </Spinner>
          <p className="mt-3">Loading your dashboard...</p>
        </Container>
      </>
    );
  }

  const openProjects = projects.filter((p) => p.status === 'active');
  const completedProjects = projects.filter((p) => p.status === 'completed');

  const roleMapping = [
    { value: 0, label: 'Buyer' },
    { value: 1, label: 'Seller' },
    { value: 2, label: 'Buyer Solicitor' },
    { value: 3, label: 'Seller Solicitor' },
    { value: 4, label: 'Estate Agent' },
    { value: 5, label: 'Mortgage Advisor' },
    { value: 6, label: 'Mortgage Vendor' },
    { value: 7, label: 'Deposit Gifter' },
  ];

  const renderProject = (proj) => (
    <Col key={proj.project_id} xs={12} md={6} lg={4}>
      <Card className="mb-4">
        <Card.Body>
          <Card.Title>{proj.project_name}</Card.Title>
          <Card.Text>{proj.description}</Card.Text>
          <Card.Text>
            <strong>Status:</strong> {proj.status.charAt(0).toUpperCase() + proj.status.slice(1)}
          </Card.Text>
          <Card.Text>
            <strong>Created:</strong> {new Date(proj.created_at).toLocaleString()}
          </Card.Text>
          <Card.Text>
            <strong>Last Updated:</strong> {new Date(proj.updated_at).toLocaleString()}
          </Card.Text>
          {proj.collaborators && proj.collaborators.length > 0 && (
            <div>
              <strong>Collaborators:</strong>
              <ul>
                {proj.collaborators.map((c) => {
                  const roleObj = roleMapping.find((r) => r.value === c.role);
                  const roleLabel = roleObj ? roleObj.label : 'Unknown';
                  return (
                    <li key={c.user_id}>
                      {c.user?.email || 'N/A'} - {roleLabel}
                    </li>
                  );
                })}
              </ul>
            </div>
          )}
          <div className="d-flex justify-content-between">
            <Button variant="primary" onClick={() => navigate(`/projects/${proj.project_id}`)}>
              View Details
            </Button>
            <Button variant="danger" onClick={() => deleteProject(proj.project_id)}>
              Delete
            </Button>
          </div>
        </Card.Body>
      </Card>
    </Col>
  );

  return (
    <>
      <Header />
      <Container className="mt-5">
        <div className="section">
          <h1>Welcome to Your Dashboard</h1>
          <p>Here are your projects:</p>

          <h2>Open Projects</h2>
          {openProjects.length === 0 ? (
            <p>No open projects.</p>
          ) : (
            <Row>{openProjects.map(renderProject)}</Row>
          )}

          <h2>Completed Projects</h2>
          {completedProjects.length === 0 ? (
            <p>No completed projects.</p>
          ) : (
            <Row>{completedProjects.map(renderProject)}</Row>
          )}

          <div className="d-flex justify-content-center mt-4">
            <Button variant="success" onClick={() => navigate('/projects/create')}>
              Create New Project
            </Button>
          </div>
        </div>
      </Container>
    </>
  );
}

export default Dashboard;