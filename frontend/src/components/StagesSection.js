// src/components/StagesSection.js

import React, { useState, useContext } from 'react';
import axios from 'axios';
import { toast } from 'react-toastify';
import TaskForm from './TaskForm';
import { Accordion, Table, Button, OverlayTrigger, Tooltip, Badge } from 'react-bootstrap';
import { useNavigate } from 'react-router-dom';
import { FaCheck, FaCheckCircle, FaPaperclip } from 'react-icons/fa';
import { UserContext } from '../context/UserContext';

/**
 * StagesSection
 * - Now includes a count of how many incomplete tasks are assigned to the current user
 *   in each stage, displayed as a Badge in the stage header.
 * - Also highlights tasks that are assigned to the user in the table.
 */

function StagesSection({ projectId, stages, refetchProject, collaborators = [] }) {
  const [showTaskForm, setShowTaskForm] = useState(false);
  const [taskToEdit, setTaskToEdit] = useState(null);
  const [mode, setMode] = useState('create');

  const navigate = useNavigate();
  const { user } = useContext(UserContext);
  const currentUserId = user?.user_id || null;

  // Edit Task
  const handleEditTask = async (task) => {
    try {
      const token = localStorage.getItem('jwtToken');
      if (!token) {
        toast.warn('You must be logged in to edit a task.');
        return;
      }

      // Attempt to fetch the full task data
      const response = await axios.get(`${process.env.REACT_APP_API_URL}/tasks/${task.task_id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setTaskToEdit(response.data);
      setMode('edit');
      setShowTaskForm(true);
    } catch (error) {
      // If we get a 403 or 404, we can show the appropriate message
      if (error.response && error.response.status === 403) {
        // Possibly avoid duplicated toast if your interceptor does it,
        // but let's show something user-friendly:
        toast.error('You do not have permission to edit this task.');
      } else if (error.response && error.response.status === 404) {
        toast.error('Task not found or insufficient permissions.');
      } else {
        toast.error('Failed to fetch task for editing.');
      }
    }
  };

  // Create Task
  const handleCreateTask = () => {
    setTaskToEdit(null);
    setMode('create');
    setShowTaskForm(true);
  };

  // After form submission
  const handleTaskFormSubmit = () => {
    setShowTaskForm(false);
    setTaskToEdit(null);
    refetchProject();
  };

  // Complete Task inline
  const handleCompleteTask = async (task) => {
    const token = localStorage.getItem('jwtToken');
    if (!token) {
      toast.warn('You must be logged in to complete a task.');
      return;
    }
    try {
      await axios.put(
        `${process.env.REACT_APP_API_URL}/tasks/${task.task_id}/complete`,
        {},
        { headers: { Authorization: `Bearer ${token}` } }
      );
      toast.success('Task marked as completed!');
      refetchProject();
    } catch (err) {
      if (err.response && err.response.status === 403) {
        toast.error('You do not have permission to complete this task.');
      } else if (err.response && err.response.status === 404) {
        toast.error('Task not found or insufficient permissions.');
      } else {
        toast.error('Could not complete task.');
      }
    }
  };

  /**
   * Render attachments tooltip
   */
  const renderDocsTooltip = (task) => {
    if (!task.documents || task.documents.length === 0) return null;

    const docLines = task.documents.map((d) => {
      const tag = d.tags && d.tags.length > 0 ? d.tags[0] : '(No Tag)';
      const orig = d.original_filename || d.file_name || 'unknown';
      const user = d.uploaded_by || 'unknown user';
      const dateStr = d.uploaded_date ? new Date(d.uploaded_date).toLocaleString() : 'unknown date';
      return (
        <div key={d.document_id}>
          <strong>{tag}</strong> | {orig} | {user} | {dateStr}
        </div>
      );
    });

    return (
      <OverlayTrigger
        placement="top"
        overlay={
          <Tooltip id={`tooltip-docs-${task.task_id}`}>
            {docLines}
          </Tooltip>
        }
      >
        <FaPaperclip style={{ marginLeft: '8px', cursor: 'pointer' }} />
      </OverlayTrigger>
    );
  };

  /**
   * Renders the Task cell, highlighting if assigned to the current user
   */
  const renderTaskCell = (task) => {
    const isCompleted = task.is_completed;
    // Check if current user is assigned
    const isAssigned = task.assigned_users?.some((u) => u.user_id === currentUserId);

    // We'll color code or bold the text if the user is assigned
    const style = {
      fontWeight: isAssigned ? 'bold' : 'normal',
      color: isAssigned ? '#0d6efd' : 'inherit', // e.g. bootstrap's primary color
      display: 'flex',
      alignItems: 'center',
    };

    return (
      <div style={style}>
        {task.task_name}
        {isCompleted && (
          <FaCheckCircle size="1em" style={{ color: 'green', marginLeft: '5px' }} />
        )}
        {task.documents && task.documents.length > 0 && renderDocsTooltip(task)}
      </div>
    );
  };

  /**
   * Count how many incomplete tasks in a stage are assigned to the current user
   */
  const countUserIncompleteAssignedTasks = (stage) => {
    if (!currentUserId) return 0;
    if (!stage.tasks || stage.tasks.length === 0) return 0;
    let count = 0;
    stage.tasks.forEach((task) => {
      const isAssigned = task.assigned_users?.some((u) => u.user_id === currentUserId);
      if (isAssigned && !task.is_completed) count += 1;
    });
    return count;
  };

  return (
    <div className="stages-section section mt-4">
      <div className="d-flex justify-content-between align-items-center mb-3">
        <h2>Stages</h2>
        <Button variant="success" onClick={handleCreateTask}>
          Add Task
        </Button>
      </div>

      {stages && stages.length > 0 ? (
        <Accordion defaultActiveKey="0" alwaysOpen>
          {stages
            .sort((a, b) => a.stage_order - b.stage_order)
            .map((stage, idx) => {
              const assignedIncompleteCount = countUserIncompleteAssignedTasks(stage);

              return (
                <Accordion.Item eventKey={String(idx)} key={stage.stage_id}>
                  <Accordion.Header>
                    <strong>
                      Stage {stage.stage_order}: {stage.stage_name}
                    </strong>
                    {assignedIncompleteCount > 0 && (
                      <Badge bg="info" className="ms-2">
                        {assignedIncompleteCount} task
                        {assignedIncompleteCount > 1 ? 's' : ''} assigned to you
                      </Badge>
                    )}
                  </Accordion.Header>
                  <Accordion.Body>
                    {stage.tasks && stage.tasks.length > 0 ? (
                      <div className="table-responsive">
                        <Table hover borderless>
                          <thead>
                            <tr>
                              <th>Task</th>
                              <th>Due Date</th>
                              <th style={{ width: '30%' }}>Actions</th>
                            </tr>
                          </thead>
                          <tbody>
                            {stage.tasks.map((task) => {
                              const isCompleted = task.is_completed;
                              return (
                                <tr
                                  key={task.task_id}
                                  style={{
                                    backgroundColor: isCompleted ? '#e2e3e5' : '',
                                    opacity: isCompleted ? 0.8 : 1,
                                  }}
                                >
                                  <td>{renderTaskCell(task)}</td>
                                  <td>
                                    {task.due_date
                                      ? new Date(task.due_date).toLocaleDateString()
                                      : '-'}
                                  </td>
                                  <td>
                                    <Button
                                      variant="outline-success"
                                      size="sm"
                                      className="me-2"
                                      disabled={isCompleted}
                                      onClick={() => handleCompleteTask(task)}
                                    >
                                      <FaCheck />
                                    </Button>
                                    <Button
                                      variant="outline-primary"
                                      size="sm"
                                      className="me-2"
                                      onClick={() => handleEditTask(task)}
                                    >
                                      Edit
                                    </Button>
                                  </td>
                                </tr>
                              );
                            })}
                          </tbody>
                        </Table>
                      </div>
                    ) : (
                      <p>No tasks in this stage yet.</p>
                    )}
                  </Accordion.Body>
                </Accordion.Item>
              );
            })}
        </Accordion>
      ) : (
        <p>No stages found.</p>
      )}

      {showTaskForm && (
        <TaskForm
          mode={mode}
          taskData={taskToEdit}
          onSubmit={handleTaskFormSubmit}
          onCancel={() => {
            setShowTaskForm(false);
            setTaskToEdit(null);
          }}
          stages={stages}
          initialStageId={mode === 'edit' && taskToEdit ? String(taskToEdit.stage_id) : ''}
          projectId={projectId}
          isModal
          collaborators={collaborators}
        />
      )}
    </div>
  );
}

export default StagesSection;