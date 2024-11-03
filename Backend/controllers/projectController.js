// controllers/projectController.js

const db = require('../models'); // Import all models via db
const { Project, Stage, User, ProjectCollaborators } = db; // Destructure specific models as needed

// Define default stages
const defaultStages = [
    { stage_name: 'Viewings', description: 'Initial viewings of the property', stage_order: 1 },
    { stage_name: 'Offer Stage', description: 'Stage of making an offer on the property', stage_order: 2 },
    { stage_name: 'Offer Accepted', description: 'Offer accepted by the seller', stage_order: 3 },
    { stage_name: 'Legal, Surveys, & Compliance', description: 'Legal checks, surveys, and compliance checks', stage_order: 4 },
    { stage_name: 'Mortgage Application', description: 'Processing of buyer’s mortgage application', stage_order: 5 },
    { stage_name: 'Contract Exchange', description: 'Exchange of contracts between buyer and seller', stage_order: 6 },
    { stage_name: 'Key Exchange', description: 'Final exchange of keys and property ownership', stage_order: 7 },
    { stage_name: 'Misc', description: 'For any tasks outside of the standard stages', stage_order: 8, is_custom: true }
];

// Middleware function to verify project ownership
function isProjectOwner(req, res, next) {
    console.log("Inside isProjectOwner middleware");
    console.log("req.params:", req.params);

    const project_id = req.params.project_id || req.params.id;
    const userId = req.user?.id;
    
    console.log("project_id:", project_id);
    console.log("userId:", userId);

    Project.findOne({ where: { project_id, owner_id: userId } })
        .then(project => {
            if (!project) {
                console.log("User is not project owner");
                return res.status(403).json({ error: "You do not have permission to access this project" });
            }
            next();
        })
        .catch(error => {
            console.error("Error checking project ownership:", error);
            res.status(500).json({ error: 'Error verifying project ownership' });
        });
}

// Create a new project and add default stages
//console.log("Authenticated User ID:", req.user?.id);

async function createProject(req, res) {
    try {
        const { project_name, description, start_date, end_date, status } = req.body;
        const owner_id = req.user?.id;  // Ensure owner_id is set from the authenticated user

        if (!owner_id) {
            return res.status(400).json({ error: "Owner ID is missing or invalid." });
        }

        // Step 1: Create the project with the owner_id
        const project = await Project.create({
            project_name,
            description,
            start_date,
            end_date,
            status,
            owner_id  // Include owner_id here
        });

        // Step 2: Add default stages to the project
        const stagesToAdd = defaultStages.map(stage => ({
            ...stage,
            project_id: project.project_id,
            created_at: new Date(),
            updated_at: new Date()
        }));

        await Stage.bulkCreate(stagesToAdd); // Insert all stages in one go

        res.status(201).json({ message: 'Project and default stages created successfully', project });
    } catch (error) {
        console.error("Error in createProject:", error);
        res.status(500).json({ error: 'Error creating project' });
    }
}

// Get all projects
async function getAllProjects(req, res) {
    try {
        const projects = await Project.findAll();
        res.json(projects);
    } catch (error) {
        console.error("Error in getAllProjects:", error);
        res.status(500).json({ error: 'Error retrieving projects' });
    }
}

// Get projects by authenticated user
async function getProjectsByUserId(req, res) {
    console.log("Checking Project model:", Project);  // Confirm Project model is loaded
    try {
        // Parse and validate userId
        const userId = parseInt(req.user.id, 10);
        if (isNaN(userId)) {
            console.error("Invalid user ID:", req.user.id);
            return res.status(400).json({ error: 'Invalid user ID' });
        }
        console.log("Validated user ID:", userId);

        // Fetch projects where the user is the owner, including collaborators
        const ownedProjects = await Project.findAll({
            where: { owner_id: userId },
            include: [
                {
                    model: ProjectCollaborators,
                    as: 'collaborators',
                    required: false,
                    attributes: ['user_id', 'role']
                }
            ]
        });
        console.log("Owned Projects:", ownedProjects);

        // Fetch projects where the user is a collaborator, with the alias specified
        const collaboratorProjects = await Project.findAll({
            include: [
                {
                    model: ProjectCollaborators,
                    as: 'collaborators',
                    where: { user_id: userId },
                    attributes: ['project_id'],
                    required: true  // Ensures only collaborator-linked projects are retrieved
                }
            ]
        });
        console.log("Collaborator Projects:", collaboratorProjects);

        // Merge owned and collaborated projects, removing duplicates by project_id
        const allProjects = [...ownedProjects, ...collaboratorProjects];
        const uniqueProjects = allProjects.filter((project, index, self) =>
            index === self.findIndex((p) => p.project_id === project.project_id)
        );

        res.status(200).json(uniqueProjects);
    } catch (error) {
        console.error('Error in getProjectsByUserId:', error);
        res.status(500).json({ error: 'Error retrieving user projects' });
    }
}

async function getProjectById(req, res) {
    try {
        // Parse and validate projectId
        const projectId = parseInt(req.params.id, 10);
        if (isNaN(projectId)) {
            console.error("Invalid project ID:", req.params.id);
            return res.status(400).json({ error: 'Invalid project ID' });
        }
        console.log("Validated project ID:", projectId);

        // Parse and validate userId
        const userId = parseInt(req.user.id, 10);
        if (isNaN(userId)) {
            console.error("Invalid user ID:", req.user.id);
            return res.status(400).json({ error: 'Invalid user ID' });
        }
        console.log("Validated user ID:", userId);

        const project = await Project.findOne({
            where: {
                project_id: projectId,
                owner_id: userId,
            },
            include: [
                {
                    model: ProjectCollaborators,
                    as: 'collaborators',
                    attributes: ['user_id', 'role'],
                },
            ],
        });

        if (!project) {
            console.log("Project not found or unauthorized access for project ID:", projectId);
            return res.status(404).json({ error: 'Project not found or unauthorized' });
        }

        res.status(200).json(project);
    } catch (error) {
        console.error('Error in getProjectById:', error);
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
            { where: { project_id: id, owner_id: req.user?.id } }
        );
        if (!updated) return res.status(404).json({ error: 'Project not found or unauthorized' });
        res.json({ message: 'Project updated successfully' });
    } catch (error) {
        console.error("Error in updateProject:", error);
        res.status(500).json({ error: 'Error updating project' });
    }
}

// Add a collaborator to a project
async function addCollaborator(req, res) {
    const { project_id } = req.params;
    const { email, role } = req.body;

    try {
        const project = await Project.findOne({ where: { project_id, owner_id: req.user.id } });
        if (!project) {
            return res.status(403).json({ error: "You do not have permission to add collaborators to this project" });
        }

        const collaborator = await User.findOne({ where: { email } });
        if (!collaborator) {
            return res.status(404).json({ error: 'Collaborator not found' });
        }

        const existingCollaboration = await ProjectCollaborators.findOne({
            where: { project_id, user_id: collaborator.user_id }
        });
        if (existingCollaboration) {
            return res.status(400).json({ error: 'User is already a collaborator on this project' });
        }

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
// controllers/projectController.js

// Get all collaborators for a project
async function getCollaborators(req, res) {
    try {
        const { project_id } = req.params;

        // Query collaborators with associated user details using correct alias
        const collaborators = await ProjectCollaborators.findAll({
            where: { project_id },
            include: [{ model: User, as: 'user', attributes: ['email', 'first_name', 'last_name'] }]
        });

        res.status(200).json(collaborators);
    } catch (error) {
        console.error("Error in getCollaborators:", error);
        res.status(500).json({ error: "Error retrieving collaborators" });
    }
}

// New function to get all stages for a project
async function getStages(req, res) {
    try {
        const { project_id } = req.params;
        const stages = await Stage.findAll({ where: { project_id } });
        res.status(200).json(stages);
    } catch (error) {
        console.error("Error in getStages:", error);
        res.status(500).json({ error: "Error retrieving stages" });
    }
}

// Get a specific stage by ID
async function getStageById(req, res) {
    try {
        const { project_id, stage_id } = req.params;
        console.log("Fetching stage with project_id:", project_id, "and stage_id:", stage_id);

        // Ensure `project_id` and `stage_id` are integers for query matching
        const stage = await Stage.findOne({
            where: {
                project_id: parseInt(project_id, 10),
                stage_id: parseInt(stage_id, 10)
            }
        });

        if (!stage) {
            console.log("Stage not found for project:", project_id, "and stage_id:", stage_id);
            return res.status(404).json({ error: 'Stage not found or unauthorized' });
        }

        console.log("Stage found:", stage);  // Log the retrieved stage
        res.status(200).json(stage);
    } catch (error) {
        console.error("Error in getStageById:", error);
        res.status(500).json({ error: "Error retrieving stage" });
    }
}

// New function to create a custom stage
async function createStage(req, res) {
    try {
        const { project_id } = req.params;
        const { stage_name, description, stage_order } = req.body;

        const newStage = await Stage.create({
            project_id,
            stage_name,
            description,
            stage_order,
            is_custom: true
        });

        res.status(201).json({ message: 'Custom stage created successfully', stage: newStage });
    } catch (error) {
        console.error("Error in createStage:", error);
        res.status(500).json({ error: "Error creating stage" });
    }
}

// Update an existing stage
async function updateStage(req, res) {
    try {
        const { project_id, stage_id } = req.params;
        const { stage_name, description, stage_order } = req.body;

        const [updated] = await Stage.update(
            { stage_name, description, stage_order },
            { where: { project_id, stage_id, is_custom: true } }
        );

        if (!updated) return res.status(404).json({ error: 'Stage not found or unauthorized' });
        res.json({ message: 'Stage updated successfully' });
    } catch (error) {
        console.error("Error in updateStage:", error);
        res.status(500).json({ error: "Error updating stage" });
    }
}

// Delete an existing custom stage
async function deleteStage(req, res) {
    try {
        const { project_id, stage_id } = req.params;

        const deleted = await Stage.destroy({
            where: { project_id, stage_id, is_custom: true }
        });

        if (!deleted) return res.status(404).json({ error: 'Stage not found or unauthorized' });
        res.json({ message: 'Stage deleted successfully' });
    } catch (error) {
        console.error("Error in deleteStage:", error);
        res.status(500).json({ error: "Error deleting stage" });
    }
}

// Update a collaborator's role
async function updateCollaborator(req, res) {
    try {
        const { project_id, collaborator_id } = req.params;
        const { role } = req.body;

        const [updated] = await ProjectCollaborators.update(
            { role },
            { where: { project_id, collaborator_id } }
        );
        if (!updated) return res.status(404).json({ error: 'Collaborator not found or unauthorized' });
        res.json({ message: 'Collaborator role updated successfully' });
    } catch (error) {
        console.error("Error in updateCollaborator:", error);
        res.status(500).json({ error: 'Error updating collaborator' });
    }
}

// Delete a collaborator from a project
async function deleteCollaborator(req, res) {
    try {
        const { project_id, collaborator_id } = req.params;

        const deleted = await ProjectCollaborators.destroy({
            where: { project_id, collaborator_id }
        });
        if (!deleted) return res.status(404).json({ error: 'Collaborator not found or unauthorized' });
        res.json({ message: 'Collaborator removed successfully' });
    } catch (error) {
        console.error("Error in deleteCollaborator:", error);
        res.status(500).json({ error: 'Error removing collaborator' });
    }
}

// Delete project by project ID
async function deleteProject(req, res) {
    try {
        const { id } = req.params;
        const deleted = await Project.destroy({ where: { project_id: id, owner_id: req.user?.id } });
        if (!deleted) return res.status(404).json({ error: 'Project not found or unauthorized' });
        res.json({ message: 'Project deleted successfully' });
    } catch (error) {
        console.error("Error in deleteProject:", error);
        res.status(500).json({ error: 'Error deleting project' });
    }
}
// testing start

const testProjectCollaboratorsAssociation = async (req, res) => {
    try {
        // Attempt to retrieve all ProjectCollaborators with their associated Project
        const collaborators = await ProjectCollaborators.findAll({
            include: [
                {
                    model: Project,
                    as: 'project'  // Ensure this matches the alias in your model
                }
            ]
        });

        res.status(200).json(collaborators);
    } catch (error) {
        console.error("Error in testProjectCollaboratorsAssociation:", error);
        res.status(500).json({ error: "Error testing ProjectCollaborators association" });
    }
};



///testing stop
module.exports = {
    createProject,
    getAllProjects,
    getProjectsByUserId,
    getCollaborators,
    addCollaborator,
    getStages,
    getStageById,
    createStage,
    updateStage,
    deleteStage,
    getProjectById,
    updateProject,
    updateCollaborator,
    deleteCollaborator,
    deleteProject,
    isProjectOwner,
    testProjectCollaboratorsAssociation  // Added a comma before this line
};