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
router.post('/:project_id/collaborators', isAuthenticated, projectController.addCollaborator);


module.exports = router;