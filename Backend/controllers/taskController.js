const { Op } = require('sequelize');
const { Task, Project, Stage, taskassignment, User } = require('../models');  // Import necessary models



// Create a new task
async function createTask(req, res) {
    try {
        const { project_id, stage_id, task_name, description, due_date, priority } = req.body;
        const userId = req.user.id;  // The creator's ID, which will be set as the task owner

        // Verify project and stage validity
        const project = await Project.findByPk(project_id);
        const stage = await Stage.findByPk(stage_id);
        
        if (!project || !stage) {
            return res.status(400).json({ error: "Invalid project or stage association." });
        }

        // Create the task with only the task owner
        const task = await Task.create({
            project_id,
            stage_id,
            task_name,
            description,
            due_date,
            priority,
            owner_id: userId,  // Set the creator as the owner
        });

        res.status(201).json({ message: 'Task created successfully', task });
    } catch (error) {
        console.error("Error in createTask:", error);
        res.status(500).json({ error: 'Error creating task' });
    }
}

// Retrieve a specific task
// Retrieve a specific task
async function getTaskById(req, res) {
    try {
        const { task_id } = req.params;
        const userId = req.user.id;

        const task = await Task.findByPk(task_id, {
            include: [
                {
                    model: User,
                    as: 'assigned_users',
                    attributes: ['user_id'],  // Use 'user_id' to match the schema
                    through: {
                        attributes: ['can_view', 'can_edit'],  // Only include permission fields
                    }
                }
            ]
        });

        if (!task) return res.status(404).json({ error: 'Task not found' });

        const hasFullAccess = task.owner_id === userId || task.assigned_users.some(user => user.user_id === userId);
        const responseData = hasFullAccess ? task : { task_name: task.task_name, is_completed: task.is_completed };

        res.status(200).json(responseData);
    } catch (error) {
        console.error("Error in getTaskById:", error);
        res.status(500).json({ error: 'Error retrieving task' });
    }
}

// GET all tasks for which you are assigned or owner

async function getTasksByUser(req, res) {
    try {
        const userId = req.user.id;  // Get the authenticated user ID from the token

        const tasks = await Task.findAll({
            where: {
                [Op.or]: [
                    { owner_id: userId },  // Fetch tasks where the user is the owner
                    {
                        '$assigned_users.user_id$': userId  // Fetch tasks where the user is a collaborator
                    }
                ]
            },
            include: [
                {
                    model: User,
                    as: 'assigned_users',
                    attributes: ['user_id'],  // Use 'user_id' instead of 'id'
                    through: {
                        attributes: ['can_view', 'can_edit'],  // Include only relevant fields from taskassignment
                    }
                }
            ]
        });

        res.status(200).json(tasks);
    } catch (error) {
        console.error("Error in getTasksByUser:", error);
        res.status(500).json({ error: 'Error fetching tasks' });
    }
}
// Update task
async function updateTask(req, res) {
    try {
        const { task_id } = req.params;
        const userId = req.user.id;
        const { task_name, description, due_date, priority, is_completed } = req.body;

        // Retrieve the task based on ownership or edit permissions
        const task = await Task.findOne({
            where: {
                task_id,
                [Op.or]: [
                    { owner_id: userId }, // Owner
                    {
                        '$assigned_users.taskassignment.can_edit$': true,
                        '$assigned_users.user_id$': userId  // Collaborator with edit permissions
                    }
                ]
            },
            include: [
                {
                    model: User,
                    as: 'assigned_users',
                    attributes: ['user_id'],
                    through: {
                        attributes: ['can_edit']
                    }
                }
            ]
        });

        // Check if task is found
        if (!task) {
            return res.status(404).json({ error: 'Task not found or insufficient permissions' });
        }

        // Update the task if found and permission is valid
        await task.update({ task_name, description, due_date, priority, is_completed });
        res.status(200).json({ message: 'Task updated successfully', task });
    } catch (error) {
        console.error("Error in updateTask:", error);
        res.status(500).json({ error: 'Error updating task' });
    }
}

// Delete task
async function deleteTask(req, res) {
    try {
        const { task_id } = req.params;
        const userId = req.user.id;

        // Find the task based on ownership or edit permissions
        const task = await Task.findOne({
            where: {
                task_id,
                [Op.or]: [
                    { owner_id: userId }, // Owner
                    {
                        '$assigned_users.taskassignment.can_edit$': true,
                        '$assigned_users.user_id$': userId  // Collaborator with edit permissions
                    }
                ]
            },
            include: [
                {
                    model: User,
                    as: 'assigned_users',
                    attributes: ['user_id'],
                    through: {
                        attributes: ['can_edit']
                    }
                }
            ]
        });

        // Check if task is found
        if (!task) {
            return res.status(404).json({ error: 'Task not found or insufficient permissions' });
        }

        // Delete the task if permissions are valid
        await task.destroy();
        res.status(200).json({ message: 'Task deleted successfully' });
    } catch (error) {
        console.error("Error in deleteTask:", error);
        res.status(500).json({ error: 'Error deleting task' });
    }
}

// Export all task controller functions, including getTasksByUser
module.exports = { createTask, getTaskById, updateTask, deleteTask, getTasksByUser };