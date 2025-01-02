// src/pages/Dashboard.js

import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { toast } from 'react-toastify';
import {
  Container,
  Row,
  Col,
  Card,
  Button,
  Spinner,
  Table,
  Dropdown,
  ButtonGroup,
  OverlayTrigger,
  Tooltip,
  ProgressBar, // Import ProgressBar from react-bootstrap
} from 'react-bootstrap';

import { FaTrash, FaEdit, FaEye, FaUsers, FaPlus, FaCheck } from 'react-icons/fa';
import Header from '../components/Header';
import ConfirmModal from '../components/ConfirmModal';
import { v4 as uuidv4 } from 'uuid';
import { roleMapping } from '../constants/roleMapping';

function getRoleLabel(roleValue) {
  const found = roleMapping.find(r => r.value === roleValue);
  return found ? found.label : 'Unknown';
}

function Dashboard() {
  const [projects, setProjects] = useState([]);
  const [assignedTasks, setAssignedTasks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [loadingTasks, setLoadingTasks] = useState(true);
  const [showDeleteTaskModal, setShowDeleteTaskModal] = useState(false);
  const [taskToDelete, setTaskToDelete] = useState(null);
  const [showDeleteProjectModal, setShowDeleteProjectModal] = useState(false);
  const [projectToDelete, setProjectToDelete] = useState(null);
  const [showCompleteTaskModal, setShowCompleteTaskModal] = useState(false);
  const [taskToComplete, setTaskToComplete] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    fetchProjects();
    fetchAssignedTasks();
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

  const fetchAssignedTasks = async () => {
    const token = localStorage.getItem('jwtToken');
    if (!token) return;

    try {
      const response = await axios.get(`${process.env.REACT_APP_API_URL}/tasks/user-tasks`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setAssignedTasks(response.data);
      setLoadingTasks(false);
    } catch (error) {
      console.error('Error fetching assigned tasks:', error);
      toast.error('Failed to fetch your assigned tasks.');
      setLoadingTasks(false);
    }
  };

  const deleteProject = (project) => {
    setProjectToDelete(project);
    setShowDeleteProjectModal(true);
  };

  const confirmDeleteProject = async () => {
    if (!projectToDelete) return;
    const token = localStorage.getItem('jwtToken');
    try {
      await axios.delete(`${process.env.REACT_APP_API_URL}/projects/${projectToDelete.project_id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      toast.success('Project deleted successfully!');
      setShowDeleteProjectModal(false);
      setProjectToDelete(null);
      fetchProjects();
    } catch (error) {
      console.error('Error deleting project:', error);
      toast.error('Failed to delete project.');
      setShowDeleteProjectModal(false);
      setProjectToDelete(null);
    }
  };

  const markTaskAsCompleted = (task) => {
    setTaskToComplete(task);
    setShowCompleteTaskModal(true);
  };

  const confirmMarkTaskAsCompleted = async () => {
    if (!taskToComplete) return;
    const token = localStorage.getItem('jwtToken');
    try {
      await axios.put(
        `${process.env.REACT_APP_API_URL}/tasks/${taskToComplete.task_id}/complete`,
        {},
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );
      toast.success('Task marked as completed!');
      setShowCompleteTaskModal(false);
      setTaskToComplete(null);
      fetchAssignedTasks();
    } catch (error) {
      console.error('Error marking task as completed:', error);
      if (error.response && error.response.status === 403) {
        toast.error(error.response.data.error || 'You do not have permission to complete this task.');
      } else {
        toast.error('Failed to mark task as completed.');
      }
      setShowCompleteTaskModal(false);
      setTaskToComplete(null);
    }
  };

  const handleDeleteTask = (task) => {
    setTaskToDelete(task);
    setShowDeleteTaskModal(true);
  };

  const confirmDeleteTask = async () => {
    if (!taskToDelete) return;
    const token = localStorage.getItem('jwtToken');
    try {
      await axios.delete(`${process.env.REACT_APP_API_URL}/tasks/${taskToDelete.task_id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      toast.success('Task deleted successfully!');
      setShowDeleteTaskModal(false);
      setTaskToDelete(null);
      fetchAssignedTasks();
    } catch (error) {
      console.error('Error deleting task:', error);
      toast.error('Failed to delete task.');
      setShowDeleteTaskModal(false);
      setTaskToDelete(null);
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

  // Separate projects based on status
  const openProjects = projects.filter((p) => p.status === 'active');
  const completedProjects = projects.filter((p) => p.status === 'completed');

  // 1) Compute progress for each project
  // If each project has stages -> each stage has tasks -> tasks can be completed
  // We'll compute total tasks vs. completed tasks
  const calculateProjectProgress = (proj) => {
    let totalTasks = 0;
    let doneTasks = 0;
    if (proj.stages) {
      proj.stages.forEach(stage => {
        if (stage.tasks) {
          totalTasks += stage.tasks.length;
          doneTasks += stage.tasks.filter(t => t.is_completed).length;
        }
      });
    }
    if (totalTasks === 0) return 0;
    return Math.round((doneTasks / totalTasks) * 100);
  };

  const getCollaboratorInfo = (collaborator) => {
    if (!collaborator.user) {
      return { name: 'Unknown', role: 'Unknown' };
    }

    const user = collaborator.user;
    const name = `${user.first_name || ''} ${user.last_name || ''}`.trim() || 'Unknown User';
    const roleObj = roleMapping.find((r) => r.value === Number(collaborator.role));
    const roleLabel = roleObj ? roleObj.label : 'Unknown';
    return { name, role: roleLabel };
  };

  const renderCollaboratorTooltip = (collaborators) => {
    if (!collaborators || collaborators.length === 0) {
      return <span className="text-muted">No collaborators</span>;
    }

    const collaboratorInfo = collaborators.map(getCollaboratorInfo);

    return (
      <div>
        <strong>Collaborators:</strong>
        <ul className="list-unstyled mb-0">
          {collaboratorInfo.map((c, idx) => (
            <li key={idx}>
              {c.name} ({c.role})
            </li>
          ))}
        </ul>
      </div>
    );
  };

  const renderTaskActions = (task) => (
    <Dropdown as={ButtonGroup}>
      <Button
        variant="outline-secondary"
        size="sm"
        onClick={() => navigate(`/projects/${task.project_id}/tasks/${task.task_id}/edit`)}
        aria-label={`View details of task ${task.task_name}`}
      >
        <FaEye className="me-2" /> View
      </Button>
      <Dropdown.Toggle split variant="outline-secondary" id={`dropdown-split-basic-${task.task_id}`} />
      <Dropdown.Menu>
        <Dropdown.Item onClick={() => navigate(`/projects/${task.project_id}/tasks/${task.task_id}/edit`)}>
          <FaEdit className="me-2" /> Edit
        </Dropdown.Item>
        <Dropdown.Item onClick={() => handleDeleteTask(task)}>
          <FaTrash className="me-2" /> Delete
        </Dropdown.Item>
        <Dropdown.Item onClick={() => markTaskAsCompleted(task)}>
          <FaCheck className="me-2" /> Mark as Complete
        </Dropdown.Item>
      </Dropdown.Menu>
    </Dropdown>
  );

  const renderProject = (proj) => {
    const progress = calculateProjectProgress(proj);

    return (
      <Col key={proj.project_id} xs={12} md={6} lg={4}>
        <Card className="mb-4 shadow h-100">
          <Card.Body className="d-flex flex-column">
            <Card.Title className="d-flex justify-content-between align-items-center">
              <span className="text-primary fw-bold">{proj.project_name}</span>
              <OverlayTrigger
                placement="top"
                overlay={
                  <Tooltip id={`tooltip-collaborators-${proj.project_id}`}>
                    {renderCollaboratorTooltip(proj.collaborators)}
                  </Tooltip>
                }
              >
                <Button variant="outline-secondary" size="sm" aria-label={`View collaborators for ${proj.project_name}`}>
                  <FaUsers className="me-2" /> Team
                </Button>
              </OverlayTrigger>
            </Card.Title>
            <Card.Text className="text-muted">{proj.description || 'No description provided.'}</Card.Text>

            {/* Progress Bar */}
            <div>
              <strong>Progress: </strong>
              <ProgressBar now={progress} label={`${progress}%`} className="mb-2" />
            </div>

            <div className="mt-2">
              <div>
                <strong>Status:</strong>{' '}
                <span className={`badge bg-${proj.status === 'active' ? 'success' : 'secondary'}`}>
                  {proj.status.charAt(0).toUpperCase() + proj.status.slice(1)}
                </span>
              </div>
              <div>
                <strong>Created:</strong> {new Date(proj.created_at).toLocaleString()}
              </div>
              <div>
                <strong>Last Updated:</strong> {new Date(proj.updated_at).toLocaleString()}
              </div>
            </div>
            <div className="mt-auto d-flex justify-content-between pt-3">
              <Button variant="outline-primary" onClick={() => navigate(`/projects/${proj.project_id}`)}>
                <FaEye className="me-2" /> View
              </Button>
              <Button variant="outline-warning" onClick={() => navigate(`/projects/${proj.project_id}/edit`)}>
                <FaEdit className="me-2" /> Edit
              </Button>
              <Button variant="outline-danger" onClick={() => deleteProject(proj)}>
                <FaTrash className="me-2" /> Delete
              </Button>
            </div>
          </Card.Body>
        </Card>
      </Col>
    );
  };

  return (
    <>
      <Header />
      <Container className="mt-5">
        <div className="section">
          <h1 className="mb-4">Welcome to Your Dashboard</h1>

          {/* Open Projects Section */}
          <Row className="align-items-center mb-3">
            <Col>
              <h2>Open Projects</h2>
            </Col>
            <Col className="text-end">
              <Button variant="success" onClick={() => navigate('/projects/create')} aria-label="Create a new project">
                <FaPlus className="me-2" /> Create New Project
              </Button>
            </Col>
          </Row>
          {openProjects.length === 0 ? (
            <p>No open projects.</p>
          ) : (
            <Row xs={1} md={2} lg={3} className="g-4">
              {openProjects.map(renderProject)}
            </Row>
          )}

          {/* Completed Projects Section */}
          <h2 className="mt-5">Completed Projects</h2>
          {completedProjects.length === 0 ? (
            <p>No completed projects.</p>
          ) : (
            <Row xs={1} md={2} lg={3} className="g-4">
              {completedProjects.map(renderProject)}
            </Row>
          )}

          {/* Your Open Tasks Section */}
          <h2 className="mt-5">Your Open Tasks</h2>
          {loadingTasks ? (
            <div className="text-center">
              <Spinner animation="border" role="status">
                <span className="visually-hidden">Loading your tasks...</span>
              </Spinner>
              <p className="mt-3">Loading your tasks...</p>
            </div>
          ) : assignedTasks.length === 0 ? (
            <p>You have no open tasks assigned.</p>
          ) : (
            <Table striped bordered hover responsive>
              <thead>
                <tr>
                  <th>Task Name</th>
                  <th>Stage</th>
                  <th>Project</th>
                  <th>Due Date</th>
                  <th>Priority</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {assignedTasks.map((task) => (
                  <tr key={task.task_id}>
                    <td>{task.task_name}</td>
                    <td>{task.stage ? task.stage.stage_name : 'N/A'}</td>
                    <td>{task.project ? task.project.project_name : 'N/A'}</td>
                    <td>{task.due_date ? new Date(task.due_date).toLocaleDateString() : 'N/A'}</td>
                    <td>
                      <span
                        className={`badge ${
                          task.priority === 'High'
                            ? 'bg-danger'
                            : task.priority === 'Medium'
                            ? 'bg-warning text-dark'
                            : 'bg-info text-dark'
                        }`}
                      >
                        {task.priority || 'N/A'}
                      </span>
                    </td>
                    <td>{renderTaskActions(task)}</td>
                  </tr>
                ))}
              </tbody>
            </Table>
          )}
        </div>
      </Container>

      {/* Confirm Delete Task Modal */}
      <ConfirmModal
        show={showDeleteTaskModal}
        handleClose={() => setShowDeleteTaskModal(false)}
        handleConfirm={confirmDeleteTask}
        title="Confirm Task Deletion"
        body={`Are you sure you want to delete the task "${taskToDelete?.task_name}"? This action cannot be undone.`}
      />

      {/* Confirm Delete Project Modal */}
      <ConfirmModal
        show={showDeleteProjectModal}
        handleClose={() => setShowDeleteProjectModal(false)}
        handleConfirm={confirmDeleteProject}
        title="Confirm Project Deletion"
        body={`Are you sure you want to delete the project "${projectToDelete?.project_name}"? This action cannot be undone.`}
      />

      {/* Confirm Mark Task as Complete Modal */}
      <ConfirmModal
        show={showCompleteTaskModal}
        handleClose={() => setShowCompleteTaskModal(false)}
        handleConfirm={confirmMarkTaskAsCompleted}
        title="Confirm Task Completion"
        body={`Are you sure you want to mark the task "${taskToComplete?.task_name}" as completed?`}
      />
    </>
  );
}

export default Dashboard;