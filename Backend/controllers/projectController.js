// controllers/projectController.js

const Project = require('../models/project');
const User = require('../models/user');
const ProjectCollaborators = require('../models/projectCollaborators.js'); // Import join table

// Middleware function for authenticated users
function isProjectOwner(req, res, next) {
    console.log("Inside isProjectOwner middleware"); // Log entry point
    console.log("req.params:", req.params);  // Log the req.params for debugging

    const project_id = req.params.id;  // Access the correct route parameter
    const userId = req.user?.id;
    
    console.log("project_id:", project_id); // Log project_id
    console.log("userId:", userId);         // Log userId

    Project.findOne({ where: { project_id, owner_id: userId } })
        .then(project => {
            if (!project) {
                console.log("User is not project owner"); // Log insufficient permissions
                return res.status(403).json({ error: "You do not have permission to access this project" });
            }
            next();
        })
        .catch(error => {
            console.error("Error checking project ownership:", error);
            res.status(500).json({ error: 'Error verifying project ownership' });
        });
}

// Create a new project
async function createProject(req, res) {
    try {
        const { project_name, description, start_date, end_date, status } = req.body;
        const owner_id = req.user?.id;

        console.log("Creating project with owner_id:", owner_id); // Log owner_id

        if (!owner_id) {
            return res.status(400).json({ error: "Owner ID is missing or invalid." });
        }

        const project = await Project.create({
            project_name,
            description,
            start_date,
            end_date,
            status,
            owner_id
        });

        res.status(201).json({ message: 'Project created successfully', project });
    } catch (error) {
        console.error("Error in createProject:", error);
        res.status(500).json({ error: 'Error creating project' });
    }
}

// Get all projects (for debugging or admin purposes)
async function getAllProjects(req, res) {
    try {
        console.log("Fetching all projects");
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
        console.log("Fetching projects for user:", owner_id); // Log owner_id

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
        console.log("Fetching project by ID:", id); // Log project_id
        const project = await Project.findOne({ where: { project_id: id, owner_id: req.user?.id } });
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
        console.log("Updating project with ID:", id); // Log project_id

        const [updated] = await Project.update(
            { project_name, description, start_date, end_date, status },
            { where: { project_id: id, owner_id: req.user?.id } }
        );
        if (!updated) return res.status(404).json({ error: 'Project not found or unauthorized' });
        res.json({ message: 'Project updated successfully' });
    } catch (error) {
        console.error("Error in updateProject:", error);
        res.status(500).json({ error: 'Error updating project' });
    }
}

// Middleware function for adding a collaborator to a project
async function addCollaborator(req, res) {
    const { project_id } = req.params;
    const { email, role } = req.body;  // Email of collaborator, role they will take

    console.log("Adding collaborator to project:", project_id); // Log project_id

    try {
        // Verify the authenticated user is the project owner
        const project = await Project.findOne({ where: { project_id, owner_id: req.user.id } });
        if (!project) {
            console.log("User is not authorized to add collaborators to this project");
            return res.status(403).json({ error: "You do not have permission to add collaborators to this project" });
        }

        // Find the collaborator user by email
        const collaborator = await User.findOne({ where: { email } });
        if (!collaborator) {
            return res.status(404).json({ error: 'Collaborator not found' });
        }

        // Check if collaborator is already added to the project
        const existingCollaboration = await ProjectCollaborators.findOne({
            where: { project_id, user_id: collaborator.user_id }
        });
        if (existingCollaboration) {
            return res.status(400).json({ error: 'User is already a collaborator on this project' });
        }

        // Add collaborator to project with specified role
        const newCollaboration = await ProjectCollaborators.create({
            project_id,
            user_id: collaborator.user_id,
            role,
            assigned_at: new Date()
        });

        res.status(201).json({
            message: 'Collaborator added successfully',
            collaboration: newCollaboration
        });
    } catch (error) {
        console.error("Error in addCollaborator:", error);
        res.status(500).json({ error: 'Error adding collaborator' });
    }
}

// Delete project by project ID
async function deleteProject(req, res) {
    try {
        const { id } = req.params;
        console.log("Deleting project by ID:", id); // Log project_id
        const deleted = await Project.destroy({ where: { project_id: id, owner_id: req.user?.id } });
        if (!deleted) return res.status(404).json({ error: 'Project not found or unauthorized' });
        res.json({ message: 'Project deleted successfully' });
    } catch (error) {
        console.error("Error in deleteProject:", error);
        res.status(500).json({ error: 'Error deleting project' });
    }
}

module.exports = {
    createProject,
    getAllProjects,
    getProjectsByUserId,
    addCollaborator,
    getProjectById,
    updateProject,
    deleteProject,
    isProjectOwner
};