// routes/projectRoutes.js

const express = require('express');
const router = express.Router();
const projectController = require('../controllers/projectController');
const { isAuthenticated } = require('../middleware/authMiddleware');

// Create new project
router.post('/', isAuthenticated, projectController.createProject);

// Get all projects (or based on user ID)
router.get('/', isAuthenticated, projectController.getProjectsByUserId);

// Get a specific project by ID
router.get('/:id', isAuthenticated, projectController.getProjectById);

// Update project by ID
router.put('/:id', isAuthenticated, projectController.isProjectOwner, projectController.updateProject);

// Delete project by ID
router.delete('/:id', isAuthenticated, projectController.isProjectOwner, projectController.deleteProject);

// Add project collaborators
router.post('/:project_id/collaborators', isAuthenticated, projectController.isProjectOwner, projectController.addCollaborator);

// Get project collaborators
router.get('/:project_id/collaborators', isAuthenticated, projectController.isProjectOwner, projectController.getCollaborators);

// Update a collaborator's role in a project
router.put('/:project_id/collaborators/:collaborator_id', isAuthenticated, projectController.isProjectOwner, projectController.updateCollaborator);

// Delete a collaborator from a project
router.delete('/:project_id/collaborators/:collaborator_id', isAuthenticated, projectController.isProjectOwner, projectController.deleteCollaborator);

module.exports = router;