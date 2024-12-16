// src/pages/CreateTaskPage.js

import React, { useEffect, useState } from 'react';
import TaskForm from '../components/TaskForm';
import axios from 'axios';
import { toast } from 'react-toastify';
import { useNavigate, useParams } from 'react-router-dom';
import { Container, Spinner, Button } from 'react-bootstrap';
import Header from '../components/Header';

const CreateTaskPage = () => {
  const { id: projectId } = useParams(); // Dynamic project ID from route
  const [stages, setStages] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [initialStageId, setInitialStageId] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    if (!projectId) {
      toast.error('Invalid project ID.');
      navigate('/projects');
      return;
    }

    const fetchStages = async () => {
      try {
        const token = localStorage.getItem('jwtToken');
        if (!token) {
          toast.warn('You must be logged in to create a task.');
          navigate('/login');
          return;
        }

        const response = await axios.get(`${process.env.REACT_APP_API_URL}/projects/${projectId}/stages`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        console.log('Fetched stages:', response.data);
        setStages(response.data);
        if (response.data.length > 0) {
          setInitialStageId(String(response.data[0].stage_id)); // Preselect the first stage
        }
      } catch (error) {
        console.error('Error fetching stages:', error);
        toast.error('Failed to fetch stages.');
        // Optionally, redirect back to the project page or handle the error as needed
      } finally {
        setIsLoading(false);
      }
    };

    fetchStages();
  }, [projectId, navigate]);

  const handleCreateTask = async (taskData) => {
    try {
      const token = localStorage.getItem('jwtToken');
      if (!token) {
        toast.warn('You must be logged in to create a task.');
        navigate('/login');
        return;
      }

      console.log('Creating task with data:', taskData);

      await axios.post(
        `${process.env.REACT_APP_API_URL}/tasks`,
        {
          ...taskData,
          project_id: parseInt(projectId, 10), // Ensure project ID is a number
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
        }
      );
      toast.success('Task created successfully!');
      navigate(`/projects/${projectId}`); // Redirect to project details page after creation
    } catch (error) {
      console.error('Error creating task:', error);
      if (error.response) {
        console.error('Error Response Data:', error.response.data);
        // Adjust the error message based on your backend's response structure
        toast.error(`Failed to create task: ${error.response.data.error || 'Unknown error.'}`);
      } else {
        toast.error('Failed to create task.');
      }
    }
  };

  const handleCancel = () => {
    navigate(`/projects/${projectId}`); // Redirect back to project details on cancel
  };

  if (isLoading) {
    return (
      <>
        <Header />
        <Container className="text-center mt-5">
          <Spinner animation="border" role="status">
            <span className="visually-hidden">Loading stages...</span>
          </Spinner>
          <p className="mt-3">Loading stages...</p>
        </Container>
      </>
    );
  }

  if (stages.length === 0) {
    return (
      <>
        <Header />
        <Container className="mt-5 text-center">
          <h2>No stages available.</h2>
          <p>Please add stages to create tasks.</p>
          <Button variant="primary" onClick={() => navigate(`/projects/${projectId}/add-stage`)}>
            Add Stage
          </Button>
        </Container>
      </>
    );
  }

  return (
    <>
      <Header />
      <Container className="mt-5">
        <h1>Create New Task</h1>
        <TaskForm
          key={initialStageId ? `create-${initialStageId}` : `create-new-${Date.now()}`} // Ensure unique key
          mode="create"
          onSubmit={handleCreateTask}
          onCancel={handleCancel}
          stages={stages}
          initialStageId={initialStageId} // Preselect the first stage
          projectId={projectId} // Pass projectId as prop
        />
      </Container>
    </>
  );
};

export default CreateTaskPage;