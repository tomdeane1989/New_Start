// src/components/TaskForm.js

import React, { useState, useEffect } from 'react';
import { Form, Button, Spinner, Modal } from 'react-bootstrap';
import axios from 'axios';
import { toast } from 'react-toastify';

function TaskForm({
  mode,
  taskData,
  onSubmit,
  onCancel,
  stages,
  initialStageId,
  projectId,
  isModal = true,
}) {
  const [formData, setFormData] = useState({
    task_name: taskData ? taskData.task_name : '',
    description: taskData ? taskData.description : '',
    due_date: taskData ? (taskData.due_date || '') : '',
    priority: taskData ? taskData.priority : 'Medium',
    is_completed: taskData ? taskData.is_completed : false,
    stage_id: initialStageId !== null ? Number(initialStageId) : '',
  });

  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    console.log(`TaskForm: Mode = ${mode}`);
    console.log(`TaskForm: Initial Stage ID = ${initialStageId}`);
    console.log(`TaskForm: Project ID = ${projectId}`);
    console.log('TaskForm: Received stages prop:', stages);
  }, [mode, initialStageId, projectId, stages]);

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    console.log(`TaskForm: Raw input - name: ${name}, value: ${value}, type: ${type}, checked: ${checked}`);

    const newValue =
      type === 'checkbox' ? checked : name === 'stage_id' ? Number(value) : value;

    console.log(`TaskForm: Converted value - name: ${name}, newValue: ${newValue}`);

    setFormData((prev) => ({
      ...prev,
      [name]: newValue,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log('TaskForm: Submitting form with data:', formData);
    setIsSubmitting(true);

    try {
      const token = localStorage.getItem('jwtToken');
      if (!token) {
        toast.warn('You must be logged in to perform this action.');
        onCancel();
        return;
      }

      const submissionData = {
        ...formData,
        project_id: parseInt(projectId, 10),
      };

      // If due_date is empty, remove it so the backend doesn't receive "Invalid date"
      if (!submissionData.due_date) {
        delete submissionData.due_date;
      }

      if (mode === 'edit') {
        if (!taskData || !taskData.task_id) {
          toast.error('Invalid task data.');
          setIsSubmitting(false);
          return;
        }
        console.log(`TaskForm: Editing task with ID = ${taskData.task_id}`);
        console.log('TaskForm: Form Data for PUT:', submissionData);

        await axios.put(
          `${process.env.REACT_APP_API_URL}/tasks/${taskData.task_id}`,
          submissionData,
          {
            headers: {
              Authorization: `Bearer ${token}`,
              'Content-Type': 'application/json',
            },
          }
        );
        toast.success('Task updated successfully!');
      } else {
        // Create mode
        if (!projectId) {
          toast.error('Project ID is missing.');
          setIsSubmitting(false);
          return;
        }
        console.log('TaskForm: Creating task with data:', submissionData);

        await axios.post(
          `${process.env.REACT_APP_API_URL}/tasks`,
          submissionData,
          {
            headers: {
              Authorization: `Bearer ${token}`,
              'Content-Type': 'application/json',
            },
          }
        );
        toast.success('Task created successfully!');
      }

      // Call onSubmit only after the API call is successful, so the parent can refresh data
      onSubmit(formData);
    } catch (error) {
      console.error('Error submitting task:', error);
      if (error.response) {
        toast.error(`Failed to ${mode === 'edit' ? 'update' : 'create'} task: ${error.response.data.error || 'Unknown error.'}`);
      } else {
        toast.error(`Failed to ${mode === 'edit' ? 'update' : 'create'} task.`);
      }
    } finally {
      setIsSubmitting(false);
    }
  };

  const formContent = (
    <Form onSubmit={handleSubmit}>
      <Form.Group controlId="taskName" className="mb-3">
        <Form.Label>Task Name</Form.Label>
        <Form.Control
          type="text"
          name="task_name"
          value={formData.task_name}
          onChange={handleChange}
          required
        />
      </Form.Group>

      <Form.Group controlId="description" className="mb-3">
        <Form.Label>Description</Form.Label>
        <Form.Control
          as="textarea"
          name="description"
          value={formData.description}
          onChange={handleChange}
          rows={3}
        />
      </Form.Group>

      <Form.Group controlId="dueDate" className="mb-3">
        <Form.Label>Due Date</Form.Label>
        <Form.Control
          type="date"
          name="due_date"
          value={formData.due_date}
          onChange={handleChange}
        />
      </Form.Group>

      <Form.Group controlId="priority" className="mb-3">
        <Form.Label>Priority</Form.Label>
        <Form.Select
          name="priority"
          value={formData.priority}
          onChange={handleChange}
        >
          <option value="Low">Low</option>
          <option value="Medium">Medium</option>
          <option value="High">High</option>
        </Form.Select>
      </Form.Group>

      <Form.Group controlId="isCompleted" className="mb-3">
        <Form.Check
          type="checkbox"
          label="Completed"
          name="is_completed"
          checked={formData.is_completed}
          onChange={handleChange}
        />
      </Form.Group>

      <Form.Group controlId="stageId" className="mb-3">
        <Form.Label>Stage</Form.Label>
        <Form.Select
          name="stage_id"
          value={formData.stage_id}
          onChange={handleChange}
          required
        >
          <option value="">Select Stage</option>
          {stages.map((stage) => (
            <option key={stage.stage_id} value={stage.stage_id}>
              {stage.stage_name}
            </option>
          ))}
        </Form.Select>
      </Form.Group>

      <div className="d-flex justify-content-end">
        <Button variant="secondary" onClick={onCancel} className="me-2">
          Cancel
        </Button>
        <Button variant="primary" type="submit" disabled={isSubmitting}>
          {isSubmitting ? (
            <>
              <Spinner
                as="span"
                animation="border"
                size="sm"
                role="status"
                aria-hidden="true"
                className="me-2"
              />
              Saving...
            </>
          ) : (
            'Save'
          )}
        </Button>
      </div>
    </Form>
  );

  if (isModal) {
    return (
      <Modal show onHide={onCancel}>
        <Modal.Header closeButton>
          <Modal.Title>{mode === 'edit' ? 'Edit Task' : 'Add Task'}</Modal.Title>
        </Modal.Header>
        <Modal.Body>{formContent}</Modal.Body>
      </Modal>
    );
  }

  return (
    <div className="task-form-page">
      <h2>{mode === 'edit' ? 'Edit Task' : 'Add Task'}</h2>
      {formContent}
    </div>
  );
}

export default TaskForm;