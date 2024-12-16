// src/components/StagesSection.js

import React, { useState } from 'react';
import axios from 'axios';
import { toast } from 'react-toastify';
import TaskForm from './TaskForm';
import { Table, Button, Form, Modal } from 'react-bootstrap';
import { useNavigate } from 'react-router-dom';

function StagesSection({ projectId, stages, refetchProject }) {
  const [currentStage, setCurrentStage] = useState(null);
  const [showTaskForm, setShowTaskForm] = useState(false);
  const [selectedTaskIds, setSelectedTaskIds] = useState([]);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [taskToDelete, setTaskToDelete] = useState(null);

  const navigate = useNavigate();

  // Remove any success toast here. Let TaskForm handle success for create/edit.
  const handleCreateTask = () => {
    setShowTaskForm(false);
    setCurrentStage(null);
    refetchProject();
  };

  const handleEditTaskRedirect = (task) => {
    navigate(`/projects/${projectId}/tasks/${task.task_id}/edit`);
  };

  const handleDeleteTask = async () => {
    const token = localStorage.getItem('jwtToken');
    try {
      await axios.delete(`${process.env.REACT_APP_API_URL}/tasks/${taskToDelete.task_id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      toast.success('Task deleted successfully!');
      setShowDeleteModal(false);
      setTaskToDelete(null);
      refetchProject();
    } catch (error) {
      console.error('Error deleting task:', error);
      // We will keep an error toast for when deletion fails, as it does not cause double toasts
      toast.error('Failed to delete task.');
    }
  };

  const handleDeleteSelectedTasks = async () => {
    const token = localStorage.getItem('jwtToken');
    if (selectedTaskIds.length === 0) {
      toast.warn('No tasks selected.');
      return;
    }
    if (window.confirm('Are you sure you want to delete selected tasks?')) {
      try {
        await Promise.all(
          selectedTaskIds.map((taskId) =>
            axios.delete(`${process.env.REACT_APP_API_URL}/tasks/${taskId}`, {
              headers: { Authorization: `Bearer ${token}` },
            })
          )
        );
        // Remove success toast for bulk deletion as well
        setSelectedTaskIds([]);
        refetchProject();
      } catch (error) {
        console.error('Error deleting tasks:', error);
        toast.error('Failed to delete selected tasks.');
      }
    }
  };

  const handleTaskCheckboxChange = (taskId, checked) => {
    setSelectedTaskIds((prev) => {
      if (checked) return [...prev, taskId];
      return prev.filter((id) => id !== taskId);
    });
  };

  return (
    <div className="stages-section section">
      <h2>Stages &amp; Tasks</h2>
      {stages.length > 0 ? (
        stages
          .sort((a, b) => a.stage_order - b.stage_order)
          .map((stage) => (
            <div key={stage.stage_id} className="stage-container mb-4">
              <h3>{stage.stage_name}</h3>

              {stage.tasks && stage.tasks.length > 0 ? (
                <div className="table-responsive">
                  <Table striped bordered hover>
                    <thead>
                      <tr>
                        <th>
                          <Form.Check
                            type="checkbox"
                            checked={
                              stage.tasks.length > 0 &&
                              stage.tasks.every(task => selectedTaskIds.includes(task.task_id))
                            }
                            onChange={(e) => {
                              const checked = e.target.checked;
                              const taskIds = stage.tasks.map(task => task.task_id);
                              setSelectedTaskIds(prev => {
                                if (checked) {
                                  return [...new Set([...prev, ...taskIds])];
                                } else {
                                  return prev.filter(id => !taskIds.includes(id));
                                }
                              });
                            }}
                          />
                        </th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Due Date</th>
                        <th>Priority</th>
                        <th>Completed</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      {stage.tasks.map((task) => (
                        <tr key={task.task_id}>
                          <td>
                            <Form.Check
                              type="checkbox"
                              checked={selectedTaskIds.includes(task.task_id)}
                              onChange={(e) =>
                                handleTaskCheckboxChange(task.task_id, e.target.checked)
                              }
                            />
                          </td>
                          <td>{task.task_name}</td>
                          <td>{task.description || '-'}</td>
                          <td>{task.due_date ? new Date(task.due_date).toLocaleDateString() : '-'}</td>
                          <td>
                            <span className={`badge bg-${task.priority ? task.priority.toLowerCase() : 'secondary'}`}>
                              {task.priority || 'N/A'}
                            </span>
                          </td>
                          <td>
                            {task.is_completed ? (
                              <span className="badge bg-success">Yes</span>
                            ) : (
                              <span className="badge bg-secondary">No</span>
                            )}
                          </td>
                          <td>
                            <Button
                              variant="outline-primary"
                              size="sm"
                              className="me-2"
                              onClick={() => handleEditTaskRedirect(task)}
                            >
                              Edit
                            </Button>
                            <Button
                              variant="outline-danger"
                              size="sm"
                              onClick={() => {
                                setTaskToDelete(task);
                                setShowDeleteModal(true);
                              }}
                            >
                              Delete
                            </Button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </Table>
                </div>
              ) : (
                <p>No tasks in this stage.</p>
              )}

              <Button
                variant="success"
                onClick={() => {
                  console.log('StagesSection: Selected stage_id:', stage.stage_id);
                  setCurrentStage(stage);
                  setShowTaskForm(true);
                }}
              >
                Add Task
              </Button>
            </div>
          ))
      ) : (
        <p>No stages found.</p>
      )}

      {showTaskForm && currentStage && (
        <TaskForm
          key={`create-${currentStage.stage_id}-${Date.now()}`}
          mode="create"
          taskData={null}
          onSubmit={handleCreateTask}
          onCancel={() => {
            setShowTaskForm(false);
            setCurrentStage(null);
          }}
          stages={stages}
          initialStageId={currentStage ? String(currentStage.stage_id) : ''}
          projectId={projectId}
          isModal={true}
        />
      )}

      {selectedTaskIds.length > 0 && (
        <div className="d-flex justify-content-end mt-3">
          <Button variant="danger" onClick={handleDeleteSelectedTasks}>
            Delete Selected Tasks
          </Button>
        </div>
      )}

      <Modal show={showDeleteModal} onHide={() => setShowDeleteModal(false)}>
        <Modal.Header closeButton>
          <Modal.Title>Confirm Task Deletion</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          Are you sure you want to delete the task "{taskToDelete?.task_name}"?
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={() => setShowDeleteModal(false)}>
            Cancel
          </Button>
          <Button variant="danger" onClick={handleDeleteTask}>
            Delete
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
}

export default StagesSection;