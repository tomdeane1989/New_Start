// src/pages/ProjectDetails.js

import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import axios from 'axios';
import { toast } from 'react-toastify';
import { Container, Row, Col, Spinner, Button, Card, Alert } from 'react-bootstrap'; // Imported Alert
import CollaboratorsSection from '../components/CollaboratorsSection';
import StagesSection from '../components/StagesSection';
import Header from '../components/Header';

function ProjectDetails() {
  const { id } = useParams();
  const navigate = useNavigate();

  const [project, setProject] = useState(null);
  const [loading, setLoading] = useState(true);
  const [collaborators, setCollaborators] = useState([]);

  // Define fetchProjectDetails outside of useEffect
  const fetchProjectDetails = async () => {
    try {
      const token = localStorage.getItem('jwtToken');
      const response = await axios.get(`${process.env.REACT_APP_API_URL}/projects/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      console.log('Project Data:', response.data); // Verify stages structure
      setProject(response.data);
      setLoading(false);
    } catch (error) {
      console.error('Error fetching project:', error);
      toast.error('Failed to fetch project.');
      setLoading(false);
    }
  };

  // Define fetchCollaborators outside of useEffect
  const fetchCollaborators = async () => {
    try {
      const token = localStorage.getItem('jwtToken');
      const response = await axios.get(`${process.env.REACT_APP_API_URL}/projects/${id}/collaborators`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setCollaborators(response.data);
    } catch (error) {
      console.error('Error fetching collaborators:', error);
      toast.error('Failed to fetch collaborators.');
    }
  };

  // Define refetchProject to call both fetch functions
  const refetchProject = () => {
    fetchProjectDetails();
    fetchCollaborators();
  };

  useEffect(() => {
    const token = localStorage.getItem('jwtToken');
    if (!token) {
      toast.warn('You must be logged in to view this project.');
      navigate('/login');
      return;
    }
    fetchProjectDetails();
    fetchCollaborators();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id, navigate]);

  if (loading) {
    return (
      <>
        <Header />
        <Container className="text-center mt-5">
          <Spinner animation="border" role="status">
            <span className="visually-hidden">Loading project details...</span>
          </Spinner>
          <p className="mt-3">Loading project details...</p>
        </Container>
      </>
    );
  }

  if (!project) {
    return (
      <>
        <Header />
        <Container className="mt-5">
          <Alert variant="danger">
            Project not found or you do not have access.
          </Alert>
        </Container>
      </>
    );
  }

  return (
    <>
      <Header />
      <Container className="mt-5">
        {/* Project Details */}
        <Card className="mb-4">
          <Card.Body>
            <Card.Title>{project.project_name}</Card.Title>
            <Card.Text>{project.description}</Card.Text>
            <Button variant="primary" onClick={() => navigate(`/projects/${id}/edit`)}>
              Edit Project
            </Button>
          </Card.Body>
        </Card>

        {/* Collaborators Section */}
        <CollaboratorsSection
          projectId={id}
          collaborators={collaborators}
          refetchCollaborators={fetchCollaborators}
        />

        {/* Stages and Tasks Section */}
        <StagesSection
          projectId={id}
          stages={project.stages}
          refetchProject={refetchProject}
        />
      </Container>
    </>
  );
}

export default ProjectDetails;