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
    getStages,
    getStageById,
    createStage,
    updateStage,
    deleteStage,
    approveCollaborator,
} = require('../controllers/projectController');
const authMiddleware = require('../middleware/authMiddleware');

router.use(authMiddleware);

// Project CRUD
router.post('/create', createProject);
router.get('/user', getProjectsByUserId);
router.get('/all', getAllProjects);

// Collaborator operations
router.post('/:id/collaborators', addCollaborator);
router.get('/:id/collaborators', getCollaborators);
router.put('/:id/collaborators/:collaborator_id', updateCollaborator);
router.delete('/:id/collaborators/:collaborator_id', deleteCollaborator);
router.put('/:id/collaborators/:collaborator_id/approve', approveCollaborator);

// Stage ops
router.get('/:project_id/stages/:stage_id', getStageById);
router.get('/:project_id/stages', getStages);
router.post('/:project_id/stages', createStage);
router.put('/:project_id/stages/:stage_id', updateStage);
router.delete('/:project_id/stages/:stage_id', deleteStage);

// Project detail routes
router.get('/:id', getProjectById);
router.put('/:id', updateProject);
router.delete('/:id', deleteProject);

module.exports = router;