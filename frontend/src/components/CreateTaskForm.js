// src/components/CreateTaskForm.js

import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { toast } from 'react-toastify';
import { Form, Button, Spinner } from 'react-bootstrap';

const CreateTaskForm = ({ projectId, onTaskCreated, onCancel }) => {
  const [formData, setFormData] = useState({
    stage_id: '',
    task_name: '',
    description: '',
    due_date: '',
    priority: 'Medium',
  });
  const [stages, setStages] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  // Fetch stages for the project
  useEffect(() => {
    const fetchStages = async () => {
      try {
        const token = localStorage.getItem('jwtToken');
        const response = await axios.get(`${process.env.REACT_APP_API_URL}/projects/${projectId}/stages`, {
          headers: { Authorization: `Bearer ${token}` }
        });
        setStages(response.data);
      } catch (error) {
        console.error('Error fetching stages:', error);
        toast.error('Failed to fetch stages.');
      }
    };

    fetchStages();
  }, [projectId]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log('Form Data Before Submission:', formData); // Added log
    if (!formData.stage_id) {
      toast.warn('Stage selection is required.');
      return;
    }

    try {
      setIsLoading(true);
      const token = localStorage.getItem('jwtToken');

      await axios.post(
        `${process.env.REACT_APP_API_URL}/tasks`,
        {
          ...formData,
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
      setFormData({
        stage_id: '',
        task_name: '',
        description: '',
        due_date: '',
        priority: 'Medium',
      });
      onTaskCreated(); // Callback to refresh data
    } catch (error) {
      console.error('Error creating task:', error);
      if (error.response) {
        console.error('Error Response Data:', error.response.data);
        toast.error(`Failed to create task: ${error.response.data.message || 'Unknown error.'}`);
      } else {
        toast.error('Failed to create task.');
      }
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Form onSubmit={handleSubmit} className="form-section margin-top">
      <h4>Create a New Task</h4>

      {/* Stage Selection */}
      <Form.Group controlId="stage_id" className="mb-3">
        <Form.Label>Stage</Form.Label>
        <Form.Control
          as="select"
          name="stage_id"
          value={formData.stage_id}
          onChange={handleChange}
          required
        >
          <option value="" disabled>Select a stage</option>
          {stages.map((stage) => (
            <option key={stage.stage_id} value={stage.stage_id}>
              {stage.stage_name}
            </option>
          ))}
        </Form.Control>
      </Form.Group>

      {/* Task Name */}
      <Form.Group controlId="task_name" className="mb-3">
        <Form.Label>Task Name</Form.Label>
        <Form.Control
          type="text"
          name="task_name"
          value={formData.task_name}
          onChange={handleChange}
          placeholder="Enter task name"
          required
        />
      </Form.Group>

      {/* Description */}
      <Form.Group controlId="description" className="mb-3">
        <Form.Label>Description</Form.Label>
        <Form.Control
          type="text"
          name="description"
          value={formData.description}
          onChange={handleChange}
          placeholder="Enter description (optional)"
        />
      </Form.Group>

      {/* Due Date */}
      <Form.Group controlId="due_date" className="mb-3">
        <Form.Label>Due Date</Form.Label>
        <Form.Control
          type="date"
          name="due_date"
          value={formData.due_date}
          onChange={handleChange}
        />
      </Form.Group>

      {/* Priority */}
      <Form.Group controlId="priority" className="mb-3">
        <Form.Label>Priority</Form.Label>
        <Form.Control
          as="select"
          name="priority"
          value={formData.priority}
          onChange={handleChange}
        >
          <option>Low</option>
          <option>Medium</option>
          <option>High</option>
        </Form.Control>
      </Form.Group>

      {/* Form Actions */}
      <div className="d-flex justify-content-end">
        <Button variant="secondary" onClick={onCancel} className="me-2">
          Cancel
        </Button>
        <Button variant="primary" type="submit" disabled={isLoading}>
          {isLoading ? (
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
            'Create Task'
          )}
        </Button>
      </div>
    </Form>
  );
};

export default CreateTaskForm;