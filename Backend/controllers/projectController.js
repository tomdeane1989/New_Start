// controllers/projectController.js

const Project = require('../models/project');
const User = require('../models/user');

// Middleware function for authenticated users
function isProjectOwner(req, res, next) {
    const { project_id } = req.params;
    const userId = req.user.id;

    Project.findOne({ where: { project_id, owner_id: userId } })
        .then(project => {
            if (!project) {
                return res.status(403).json({ error: "You do not have permission to access this project" });
            }
            next();
        })
        .catch(error => {
            console.error("Error checking project ownership:", error);
            res.status(500).json({ error: 'Error verifying project ownership' });
        });
}

// controllers/projectController.js

async function createProject(req, res) {
    try {
        const { project_name, description, start_date, end_date, status } = req.body;
        const owner_id = req.user?.id; // This should be retrieved from the authenticated user

        // Ensure owner_id is set
        if (!owner_id) {
            return res.status(400).json({ error: "Owner ID is missing or invalid." });
        }

        const project = await Project.create({
            project_name,
            description,
            start_date,
            end_date,
            status,
            owner_id  // Assign the authenticated user as the owner
        });

        res.status(201).json({ message: 'Project created successfully', project });
    } catch (error) {
        console.error("Error in createProject:", error);
        res.status(500).json({ error: 'Error creating project' });
    }
}

module.exports = {
    createProject,
    getAllProjects,
    getProjectsByUserId,
    getProjectById,
    updateProject,
    deleteProject,
    isProjectOwner
};

// Get all projects (for debugging or admin purposes)
async function getAllProjects(req, res) {
    try {
        const projects = await Project.findAll();
        res.json(projects);
    } catch (error) {
        console.error("Error in getAllProjects:", error);
        res.status(500).json({ error: 'Error retrieving projects' });
    }
}

// Get projects by authenticated user ID
async function getProjectsByUserId(req, res) {
    try {
        const owner_id = req.user.id;

        const projects = await Project.findAll({ where: { owner_id } });
        res.status(200).json(projects);
    } catch (error) {
        console.error('Error in getProjectsByUserId:', error);
        res.status(500).json({ error: 'Error retrieving user projects' });
    }
}

// Get a specific project by project ID
async function getProjectById(req, res) {
    try {
        const { id } = req.params;
        const project = await Project.findOne({ where: { project_id: id, owner_id: req.user.id } });
        if (!project) return res.status(404).json({ error: 'Project not found or unauthorized' });
        res.json(project);
    } catch (error) {
        console.error("Error in getProjectById:", error);
        res.status(500).json({ error: 'Error retrieving project' });
    }
}

// Update project by project ID
async function updateProject(req, res) {
    try {
        const { id } = req.params;
        const { project_name, description, start_date, end_date, status } = req.body;
        const [updated] = await Project.update(
            { project_name, description, start_date, end_date, status },
            { where: { project_id: id, owner_id: req.user.id } }
        );
        if (!updated) return res.status(404).json({ error: 'Project not found or unauthorized' });
        res.json({ message: 'Project updated successfully' });
    } catch (error) {
        console.error("Error in updateProject:", error);
        res.status(500).json({ error: 'Error updating project' });
    }
}

// Delete project by project ID
async function deleteProject(req, res) {
    try {
        const { id } = req.params;
        const deleted = await Project.destroy({ where: { project_id: id, owner_id: req.user.id } });
        if (!deleted) return res.status(404).json({ error: 'Project not found or unauthorized' });
        res.json({ message: 'Project deleted successfully' });
    } catch (error) {
        console.error("Error in deleteProject:", error);
        res.status(500).json({ error: 'Error deleting project' });
    }
}

module.exports = { createProject, getAllProjects, getProjectsByUserId, getProjectById, updateProject, deleteProject, isProjectOwner };