// routes/projectRoutes.js

const express = require('express');
const router = express.Router();
const projectController = require('../controllers/projectController');
const { isAuthenticated } = require('../middleware/authMiddleware'); // Middleware for checking authentication

router.post('/', isAuthenticated, projectController.createProject);
router.get('/', isAuthenticated, projectController.getProjectsByUserId); // Get all projects for the logged-in user
router.get('/:id', isAuthenticated, projectController.isProjectOwner, projectController.getProjectById); // View project if owner
router.put('/:id', isAuthenticated, projectController.isProjectOwner, projectController.updateProject); // Update if owner
router.delete('/:id', isAuthenticated, projectController.isProjectOwner, projectController.deleteProject); // Delete if owner

module.exports = router;