// routes/projectRoutes.js

const express = require('express');
const router = express.Router();
const projectController = require('../controllers/projectController');
const { isAuthenticated } = require('../middleware/authMiddleware');

// Project routes
router.post('/', isAuthenticated, projectController.createProject); // Create new project
router.get('/', isAuthenticated, projectController.getProjectsByUserId); // Get all projects for authenticated user
router.get('/:id', isAuthenticated, projectController.getProjectById); // Get specific project by ID
router.put('/:id', isAuthenticated, projectController.isProjectOwner, projectController.updateProject); // Update project by ID
router.delete('/:id', isAuthenticated, projectController.isProjectOwner, projectController.deleteProject); // Delete project by ID

// Collaborator routes
router.post('/:project_id/collaborators', isAuthenticated, projectController.isProjectOwner, projectController.addCollaborator); // Add collaborator to project
router.get('/:project_id/collaborators', isAuthenticated, projectController.isProjectOwner, projectController.getCollaborators); // Get all collaborators for a project
router.put('/:project_id/collaborators/:collaborator_id', isAuthenticated, projectController.isProjectOwner, projectController.updateCollaborator); // Update a collaborator's role
router.delete('/:project_id/collaborators/:collaborator_id', isAuthenticated, projectController.isProjectOwner, projectController.deleteCollaborator); // Delete collaborator from project

// Stage routes
router.get('/:project_id/stages', isAuthenticated, projectController.isProjectOwner, projectController.getStages); // Get all stages for a project
router.get('/:project_id/stages/:stage_id', isAuthenticated, projectController.isProjectOwner, projectController.getStageById); // Get specific stage by ID
router.post('/:project_id/stages', isAuthenticated, projectController.isProjectOwner, projectController.createStage); // Create custom stage
router.put('/:project_id/stages/:stage_id', isAuthenticated, projectController.isProjectOwner, projectController.updateStage); // Update existing custom stage
router.delete('/:project_id/stages/:stage_id', isAuthenticated, projectController.isProjectOwner, projectController.deleteStage); // Delete custom stage

module.exports = router;