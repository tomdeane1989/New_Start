// Backend/controllers/projectController.js
const db = require('../models');
const { Project, Stage, User, ProjectCollaborator, Task } = db;
const logger = require('../logger'); // Import Winston logger

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

const defaultTasks = {
    'Viewings': [
        'Set criteria for your housing search',
        'Determine your financial position - salary/savings/existing equity',
        'Find appropriate properties through Rightmove etc.',
        'Contact Estate Agents for further information',
        'Book viewings',
        'Invite your Mortgage Advisor (if you have one) to collaborate on A.I.P',
    ],
    'Offer Stage': [
        'Agreement in Principal with mortgage provider',
        'Offer',
        'Seller\'s response to offer',
        'Counter offer 1',
        'Seller\'s response to counter offer 1',
        'Counter offer 2',
        'Seller\'s response to counter offer 2',
    ],
    'Offer Accepted': [
        'Invite solicitor to collaborate on Conveyancing',
        'Provide solicitor contact information to seller\'s estate agent for Memorandum of Sale',
    ],
    'Legal, Surveys, & Compliance': [
        'Review and agree on costs with solicitor',
        'Decide on your need for extensive or basic surveys',
        'Confirm identity',
        'Gifted deposit administration',
    ],
    'Mortgage Application': [
        'Provide bank statements',
        'Provide payslips',
        'Provide proof of address',
        'Provide proof of identity',
        'Review affordability of mortgage payments',
        'Confirm mortgage offer',
    ],
    'Contract Exchange': [
        'Sign Mortgage offer',
        'Sign Deed of Covenant',
        'Agree on Chattels',
        'Agree completion date',
    ],
    'Misc': [],
};

// Middleware to verify project ownership
async function isProjectOwner(req, res, next) {
    try {
        const project_id = req.params.project_id || req.params.id;
        const userId = req.user?.id;

        logger.info(`Verifying ownership for project: ${project_id} by user: ${userId}`);

        const project = await Project.findOne({
            where: { project_id, owner_id: userId },
            include: [
                {
                    model: ProjectCollaborator,
                    as: 'collaborators',
                    attributes: ['user_id', 'role']
                }
            ]
        });

        if (!project) {
            logger.warn(`User ${userId} does not have permission to access project ${project_id}`);
            return res.status(403).json({ error: "You do not have permission to access this project" });
        }

        logger.info(`User ${userId} verified as owner of project ${project_id}`);
        next();
    } catch (error) {
        logger.error(`Error verifying project ownership: ${error.message}`, error);
        res.status(500).json({ error: 'Error verifying project ownership' });
    }
}

// Create Projects
async function createProject(req, res) {
    try {
        const { project_name, description, start_date, end_date, status, user_role } = req.body;
        const owner_id = req.user?.id;

        if (!owner_id) {
            logger.warn("Owner ID is missing or invalid.");
            return res.status(400).json({ error: "Owner ID is missing or invalid." });
        }

        if (user_role === undefined || (user_role !== 0 && user_role !== 1)) {
            logger.warn(`Invalid user_role: ${user_role}`);
            return res.status(400).json({ error: "Invalid user_role. Must be 0 (Buyer) or 1 (Seller)." });
        }

        const project = await Project.create({
            project_name,
            description,
            start_date,
            end_date,
            status: status || 'active',
            owner_id,
        });

        logger.info(`Project created successfully: ${project.project_id} by user_id: ${owner_id}`);

        await ProjectCollaborator.create({
            project_id: project.project_id,
            user_id: owner_id,
            role: user_role,
        });

        logger.info(`Owner assigned as collaborator with role: ${user_role}`);

        const stagesToAdd = defaultStages.map(stage => ({
            ...stage,
            project_id: project.project_id,
            created_at: new Date(),
            updated_at: new Date(),
        }));

        const stages = await Stage.bulkCreate(stagesToAdd, { returning: true });
        logger.info(`Default stages created for project_id: ${project.project_id}`);


        const thirtyDaysLater = new Date();
        thirtyDaysLater.setDate(thirtyDaysLater.getDate() + 30);

        const tasks = stages.flatMap(stage => {
            const stageTasks = defaultTasks[stage.stage_name];
            if (!stageTasks) {
                logger.warn(`No tasks defined for stage: ${stage.stage_name}`);
                return [];
            }

            return stageTasks.map(taskName => ({
                task_name: taskName,
                stage_id: stage.stage_id,
                project_id: project.project_id,
                owner_id: owner_id,
                created_at: new Date(),
                updated_at: new Date(),
                due_date: thirtyDaysLater,    // Set default due date 30 days later
                priority: 'Medium',           // Set default priority to Medium
            }));
        });

        if (tasks.length > 0) {
            await Task.bulkCreate(tasks);
            logger.info(`Default tasks created for project_id: ${project.project_id}`);
        }

        res.status(201).json({
            message: 'Project, default stages, and tasks created successfully',
            project,
        });
    } catch (error) {
        logger.error(`Error in createProject: ${error.message}`, error);
        res.status(500).json({ error: 'Error creating project' });
    }
}

// Get projects by authenticated user
async function getProjectsByUserId(req, res) {
    logger.info(`Fetching projects for user: ${req.user.id}`);

    try {
        const userId = parseInt(req.user.id, 10);
        if (isNaN(userId)) {
            logger.error(`Invalid user ID: ${req.user.id}`);
            return res.status(400).json({ error: 'Invalid user ID' });
        }

        const ownedProjects = await Project.findAll({
            where: { owner_id: userId },
            include: [
                {
                    model: ProjectCollaborator,
                    as: 'collaborators',
                    attributes: ['user_id', 'role'],
                    include: [
                        {
                            model: User,
                            as: 'user',
                            attributes: ['email', 'first_name', 'last_name'],
                        },
                    ],
                },
                {
                    model: Stage,
                    as: 'stages',
                    attributes: ['stage_id', 'stage_name', 'stage_order', 'is_custom'],
                    include: [
                        {
                            model: Task,
                            as: 'tasks',
                            attributes: ['task_id', 'created_at', 'updated_at', 'task_name', 'description', 'due_date', 'priority', 'is_completed', 'owner_id'],
                        },
                    ],
                },
            ],
        });

        logger.info(`Owned projects retrieved: ${ownedProjects.length}`);

        const collaboratorProjects = await Project.findAll({
            include: [
                {
                    model: ProjectCollaborator,
                    as: 'collaborators',
                    where: { user_id: userId },
                    required: true,
                    attributes: ['project_id'],
                },
            ],
        });

        logger.info(`Collaborator projects retrieved: ${collaboratorProjects.length}`);

        const allProjects = [...ownedProjects, ...collaboratorProjects];
        const uniqueProjects = Array.from(
            new Map(allProjects.map((project) => [project.project_id, project])).values()
        );

        logger.info(`Unique projects retrieved: ${uniqueProjects.length}`);
        res.status(200).json(uniqueProjects);
    } catch (error) {
        logger.error(`Error in getProjectsByUserId: ${error.message}`, error);
        res.status(500).json({ error: 'Failed to fetch user projects', details: error.message });
    }
}

// Get all projects
async function getAllProjects(req, res) {
    try {
        logger.info('Fetching all projects...');
        const projects = await Project.findAll({
            include: [
                {
                    model: ProjectCollaborator,
                    as: 'collaborators',
                    attributes: ['user_id', 'role'],
                    required: false,
                },
                {
                    model: Stage,
                    as: 'stages',
                    attributes: ['stage_id', 'stage_name', 'stage_order', 'is_custom'],
                    required: false,
                },
            ],
        });
        logger.info(`Found ${projects.length} projects.`);
        res.status(200).json(projects);
    } catch (error) {
        logger.error(`Error in getAllProjects: ${error.message}`, error);
        res.status(500).json({ error: 'Error retrieving all projects', details: error.message });
    }
}

async function getProjectById(req, res) {
    try {
        const projectId = parseInt(req.params.id, 10);
        if (isNaN(projectId)) {
            logger.warn(`Invalid project ID: ${req.params.id}`);
            return res.status(400).json({ error: "Invalid project ID" });
        }

        const userId = parseInt(req.user.id, 10);
        if (isNaN(userId)) {
            logger.warn(`Invalid user ID: ${req.user.id}`);
            return res.status(400).json({ error: "Invalid user ID" });
        }

        const project = await Project.findOne({
            where: { project_id: projectId },
            include: [
                {
                    model: ProjectCollaborator,
                    as: 'collaborators',
                    attributes: ['user_id', 'role'],
                    where: {
                        user_id: userId,
                    },
                    required: false,
                },
                {
                    model: Stage,
                    as: 'stages',
                    attributes: ['stage_id', 'stage_name', 'stage_order', 'is_custom'],
                    include: [
                        {
                            model: db.Task,
                            as: 'tasks',
                            // Include all necessary attributes including task_id
                            attributes: ['task_id', 'task_name', 'description', 'due_date', 'priority', 'is_completed', 'owner_id'],
                        },
                    ],
                },
            ],
        });

        if (!project) {
            logger.warn(`Project not found or unauthorized for project ID: ${projectId}`);
            return res.status(404).json({ error: "Project not found or unauthorized" });
        }

        logger.info(`Project retrieved successfully: ${projectId}`);
        res.status(200).json(project);
    } catch (error) {
        logger.error(`Error in getProjectById: ${error.message}`, error);
        res.status(500).json({ error: "Error retrieving project" });
    }
}

async function updateProject(req, res) {
    try {
        const { id } = req.params;
        const { project_name, description, start_date, end_date, status } = req.body;
        const ownerId = req.user?.id;

        if (!ownerId) {
            logger.warn("Unauthorized: Owner ID is required");
            return res.status(401).json({ error: "Unauthorized: Owner ID is required" });
        }

        logger.info(`Updating project with ID: ${id} for user ID: ${ownerId}`);

        const project = await Project.findOne({
            where: { project_id: id, owner_id: ownerId },
        });

        if (!project) {
            logger.warn("Project not found or unauthorized access.");
            return res.status(404).json({ error: "Project not found or unauthorized access" });
        }

        const updatedProject = await project.update({
            project_name,
            description,
            start_date,
            end_date,
            status,
        });

        logger.info(`Project updated successfully: ${updatedProject.project_id}`);
        res.status(200).json({ message: "Project updated successfully", project: updatedProject });
    } catch (error) {
        logger.error(`Error in updateProject: ${error.message}`, error);
        res.status(500).json({ error: "Error updating project", details: error.message });
    }
}

async function addCollaborator(req, res) {
    try {
        logger.info(`Request Params: ${JSON.stringify(req.params)}`);
        logger.info(`Request Body: ${JSON.stringify(req.body)}`);

        const { id: project_id } = req.params;
        let { email, role } = req.body;

        if (!project_id) {
            logger.error("Invalid or missing project_id in request parameters.");
            return res.status(400).json({ error: "Invalid or missing project_id in request parameters." });
        }

        const collaborator = await User.findOne({ where: { email } });

        if (!collaborator) {
            logger.error(`Collaborator not found for email: ${email}`);
            return res.status(404).json({ error: 'Collaborator not found' });
        }

        const existingCollaboration = await ProjectCollaborator.findOne({
            where: { project_id, user_id: collaborator.user_id },
        });

        if (existingCollaboration) {
            logger.warn('User is already a collaborator on this project.');
            return res.status(400).json({ error: 'User is already a collaborator on this project' });
        }

        const parsedRole = parseInt(role, 10);
        if (isNaN(parsedRole)) {
            logger.error(`Invalid integer role supplied: ${role}`);
            return res.status(400).json({ error: 'Invalid role supplied. Must be an integer.' });
        }

        const newCollaboration = await ProjectCollaborator.create({
            project_id,
            user_id: collaborator.user_id,
            role: parsedRole,
        });

        logger.info(`Collaborator added successfully: ${JSON.stringify(newCollaboration)}`);
        res.status(201).json({
            message: 'Collaborator added successfully',
            collaboration: newCollaboration,
        });
    } catch (error) {
        logger.error(`Error in addCollaborator: ${error.message}`, error);
        res.status(500).json({ error: 'Error adding collaborator', details: error.message });
    }
}

async function getCollaborators(req, res) {
    try {
        const { id } = req.params;
        const collaborators = await ProjectCollaborator.findAll({
            where: { project_id: id },
            include: [{ model: User, as: 'user', attributes: ['email', 'first_name', 'last_name'] }]
        });
        logger.info(`Collaborators retrieved for project ID ${id}: ${collaborators.length}`);
        res.status(200).json(collaborators);
    } catch (error) {
        logger.error(`Error in getCollaborators: ${error.message}`, error);
        res.status(500).json({ error: "Error retrieving collaborators" });
    }
}

async function getStages(req, res) {
    try {
        const { project_id } = req.params;
        const stages = await Stage.findAll({ where: { project_id } });
        logger.info(`Stages retrieved for project_id ${project_id}: ${stages.length}`);
        res.status(200).json(stages);
    } catch (error) {
        logger.error(`Error in getStages: ${error.message}`, error);
        res.status(500).json({ error: "Error retrieving stages" });
    }
}

async function getStageById(req, res) {
    try {
        const { project_id, stage_id } = req.params;
        logger.info(`Fetching stage with project_id: ${project_id} and stage_id: ${stage_id}`);

        const stage = await Stage.findOne({
            where: {
                project_id: parseInt(project_id, 10),
                stage_id: parseInt(stage_id, 10)
            }
        });

        if (!stage) {
            logger.warn(`Stage not found for project_id: ${project_id} and stage_id: ${stage_id}`);
            return res.status(404).json({ error: 'Stage not found or unauthorized' });
        }

        logger.info(`Stage found: ${stage.stage_id} in project ${project_id}`);
        res.status(200).json(stage);
    } catch (error) {
        logger.error(`Error in getStageById: ${error.message}`, error);
        res.status(500).json({ error: "Error retrieving stage" });
    }
}

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

        logger.info(`Custom stage created successfully: ${newStage.stage_id} in project ${project_id}`);
        res.status(201).json({ message: 'Custom stage created successfully', stage: newStage });
    } catch (error) {
        logger.error(`Error in createStage: ${error.message}`, error);
        res.status(500).json({ error: "Error creating stage" });
    }
}

async function updateStage(req, res) {
    try {
        const { project_id, stage_id } = req.params;
        const { stage_name, description, stage_order } = req.body;

        logger.info(`Updating stage with ID: ${stage_id} in project: ${project_id}`);

        const [updated] = await Stage.update(
            { stage_name, description, stage_order },
            { where: { project_id, stage_id, is_custom: true } }
        );

        if (!updated) {
            logger.warn(`Stage not found or unauthorized for update: project_id=${project_id}, stage_id=${stage_id}`);
            return res.status(404).json({ error: 'Stage not found or unauthorized' });
        }

        logger.info(`Stage updated successfully: ${stage_id} in project ${project_id}`);
        res.json({ message: 'Stage updated successfully' });
    } catch (error) {
        logger.error(`Error in updateStage: ${error.message}`, error);
        res.status(500).json({ error: "Error updating stage" });
    }
}

async function deleteStage(req, res) {
    try {
        const { project_id, stage_id } = req.params;

        logger.info(`Deleting stage with ID: ${stage_id} from project: ${project_id}`);

        const deleted = await Stage.destroy({
            where: { project_id, stage_id, is_custom: true }
        });

        if (!deleted) {
            logger.warn(`Stage not found or unauthorized for deletion: project_id=${project_id}, stage_id=${stage_id}`);
            return res.status(404).json({ error: 'Stage not found or unauthorized' });
        }

        logger.info(`Stage deleted successfully: ${stage_id} from project ${project_id}`);
        res.json({ message: 'Stage deleted successfully' });
    } catch (error) {
        logger.error(`Error in deleteStage: ${error.message}`, error);
        res.status(500).json({ error: "Error deleting stage" });
    }
}

async function updateCollaborator(req, res) {
    try {
        const { id: project_id, collaborator_id } = req.params;
        const { role } = req.body;

        logger.info(`Updating collaborator: project_id=${project_id}, collaborator_id=${collaborator_id}, role=${role}`);

        if (!project_id || !collaborator_id) {
            logger.error("Missing project_id or collaborator_id.");
            return res.status(400).json({ error: "Missing project_id or collaborator_id." });
        }

        const parsedRole = parseInt(role, 10);
        if (isNaN(parsedRole)) {
            logger.error(`Invalid or missing integer role: ${role}`);
            return res.status(400).json({ error: "Invalid or missing integer role in request body." });
        }

        logger.info(`Updating collaborator with: project_id=${project_id}, collaborator_id=${collaborator_id}, parsedRole=${parsedRole}`);

        const [updated] = await ProjectCollaborator.update(
            { role: parsedRole },
            { where: { project_id, collaborator_id } }
        );

        if (!updated) {
            logger.warn("Collaborator not found or unauthorized.");
            return res.status(404).json({ error: "Collaborator not found or unauthorized" });
        }

        logger.info("Collaborator role updated successfully.");
        res.json({ message: "Collaborator role updated successfully" });
    } catch (error) {
        logger.error(`Error in updateCollaborator: ${error.message}`, error);
        res.status(500).json({ error: "Error updating collaborator" });
    }
}

async function deleteCollaborator(req, res) {
    try {
        const { project_id, collaborator_id } = req.params;

        logger.info(`Deleting collaborator: project_id=${project_id}, collaborator_id=${collaborator_id}`);

        const deleted = await ProjectCollaborator.destroy({
            where: { project_id, collaborator_id }
        });
        if (!deleted) {
            logger.warn(`Collaborator not found or unauthorized: project_id=${project_id}, collaborator_id=${collaborator_id}`);
            return res.status(404).json({ error: 'Collaborator not found or unauthorized' });
        }
        logger.info(`Collaborator removed successfully: collaborator_id=${collaborator_id} from project_id=${project_id}`);
        res.json({ message: 'Collaborator removed successfully' });
    } catch (error) {
        logger.error(`Error in deleteCollaborator: ${error.message}`, error);
        res.status(500).json({ error: 'Error removing collaborator' });
    }
}

async function deleteProject(req, res) {
    try {
        const { id } = req.params;
        logger.info(`Deleting project with ID: ${id} by user ID: ${req.user?.id}`);

        const deleted = await Project.destroy({ where: { project_id: id, owner_id: req.user?.id } });
        if (!deleted) {
            logger.warn(`Project not found or unauthorized for deletion: project_id=${id}`);
            return res.status(404).json({ error: 'Project not found or unauthorized' });
        }
        logger.info(`Project deleted successfully: project_id=${id}`);
        res.json({ message: 'Project deleted successfully' });
    } catch (error) {
        logger.error(`Error in deleteProject: ${error.message}`, error);
        res.status(500).json({ error: 'Error deleting project' });
    }
}

// Testing start
const testProjectCollaboratorsAssociation = async (req, res) => {
    try {
        const collaborators = await ProjectCollaborator.findAll({
            include: [
                {
                    model: Project,
                    as: 'project'
                }
            ]
        });

        logger.info(`Testing ProjectCollaborators association: Retrieved ${collaborators.length} collaborators.`);
        res.status(200).json(collaborators);
    } catch (error) {
        logger.error(`Error in testProjectCollaboratorsAssociation: ${error.message}`, error);
        res.status(500).json({ error: "Error testing ProjectCollaborators association" });
    }
};
// Testing stop

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
    testProjectCollaboratorsAssociation,
};