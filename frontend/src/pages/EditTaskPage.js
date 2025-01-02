// src/pages/EditTaskPage.js

import React, { useEffect, useState } from 'react';
import TaskForm from '../components/TaskForm';
import axios from 'axios';
import { toast } from 'react-toastify';
import { useNavigate, useParams } from 'react-router-dom';
import { Container, Spinner, Alert } from 'react-bootstrap';
import Header from '../components/Header';

function EditTaskPage() {
  const { projectId, taskId } = useParams();
  const navigate = useNavigate();

  const [stages, setStages] = useState([]);
  const [taskData, setTaskData] = useState(null);
  const [isLoading, setIsLoading] = useState(true);

  // Fetch stages and task data
  useEffect(() => {
    const fetchData = async () => {
      try {
        const token = localStorage.getItem('jwtToken');
        if (!token) {
          toast.warn('You must be logged in to edit a task.');
          navigate('/login');
          return;
        }

        // Fetch stages
        const stagesResponse = await axios.get(`${process.env.REACT_APP_API_URL}/projects/${projectId}/stages`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        setStages(stagesResponse.data);

        // Fetch task data
        const taskResponse = await axios.get(`${process.env.REACT_APP_API_URL}/tasks/${taskId}`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        setTaskData(taskResponse.data);
      } catch (error) {
        console.error('Error fetching data:', error);
        toast.error('Failed to fetch task or stages.');
        navigate(`/projects/${projectId}`);
      } finally {
        setIsLoading(false);
      }
    };

    if (projectId && taskId) {
      fetchData();
    } else {
      toast.error('Invalid project or task ID.');
      navigate('/projects');
    }
  }, [projectId, taskId, navigate]);

  // Handle form submission
  const handleEditTask = async (updatedTaskData) => {
    try {
      const token = localStorage.getItem('jwtToken');
      if (!token) {
        toast.warn('You must be logged in to edit a task.');
        navigate('/login');
        return;
      }

      await axios.put(
        `${process.env.REACT_APP_API_URL}/tasks/${taskId}`,
        {
          ...updatedTaskData,
          project_id: parseInt(projectId, 10), // Ensure project ID is a number
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
        }
      );
      navigate(`/projects/${projectId}`); // Redirect to project details page after editing
    } catch (error) {
      console.error('Error editing task:', error);
      if (error.response) {
        console.error('Error Response Data:', error.response.data);
        toast.error(`Failed to update task: ${error.response.data.error || 'Unknown error.'}`);
      } else {
        toast.error('Failed to update task.');
      }
    }
  };

  // Handle cancel action
  const handleCancel = () => {
    navigate(`/projects/${projectId}`); // Redirect back to project details on cancel
  };

  if (isLoading) {
    return (
      <>
        <Header />
        <Container className="text-center mt-5">
          <Spinner animation="border" role="status">
            <span className="visually-hidden">Loading task data...</span>
          </Spinner>
          <p className="mt-3">Loading task data...</p>
        </Container>
      </>
    );
  }

  if (!taskData) {
    return (
      <>
        <Header />
        <Container className="mt-5">
          <Alert variant="danger">
            Task not found or you do not have access.
          </Alert>
        </Container>
      </>
    );
  }

  return (
    <>
      <Header />
      <Container className="mt-5">
        <h1>Edit Task</h1>
        <TaskForm
          mode="edit"
          taskData={taskData}
          onSubmit={handleEditTask}
          onCancel={handleCancel}
          stages={stages}
          initialStageId={String(taskData.stage_id)} // Preselect the task's current stage
          projectId={projectId} // Pass projectId as prop
          isModal={false} // Render as standalone form
        />
      </Container>
    </>
  );
}

export default EditTaskPage;