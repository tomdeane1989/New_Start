// Backend/routes/projectRoutes.js
const express = require('express');
const router = express.Router();
const {
    createProject,
    getProjectsByUserId,
    getAllProjects,
    getProjectById,
    updateProject,
    deleteProject,
    addCollaborator,
    getCollaborators,
    updateCollaborator,
    deleteCollaborator,
    getStages,       // Imported for stage-specific operations
    getStageById,    // Imported for fetching a specific stage
    createStage,     // Imported for creating custom stages
    updateStage,     // Imported for updating custom stages
    deleteStage,     // Imported for deleting custom stages
} = require('../controllers/projectController');
const authMiddleware = require('../middleware/authMiddleware');

// Apply authentication to all project routes
router.use(authMiddleware);

// Project CRUD operations
router.post('/create', createProject);
router.get('/user', getProjectsByUserId);
router.get('/all', getAllProjects);

// Collaborator operations
router.post('/:id/collaborators', addCollaborator);
router.get('/:id/collaborators', getCollaborators);
router.put('/:id/collaborators/:collaborator_id', updateCollaborator);
router.delete('/:id/collaborators/:collaborator_id', deleteCollaborator);

// Stage operations
router.get('/:project_id/stages/:stage_id', getStageById); // Fetch specific stage
router.get('/:project_id/stages', getStages);               // Fetch all stages
router.post('/:project_id/stages', createStage);            // Create a custom stage
router.put('/:project_id/stages/:stage_id', updateStage);   // Update a custom stage
router.delete('/:project_id/stages/:stage_id', deleteStage); // Delete a custom stage

// Project detail routes (should come after more specific routes to prevent conflicts)
router.get('/:id', getProjectById);
router.put('/:id', updateProject);
router.delete('/:id', deleteProject);

module.exports = router;