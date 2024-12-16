// Backend/controllers/taskController.js
const { Op } = require('sequelize');
const { Task, Project, Stage, TaskAssignment, User } = require('../models');
const logger = require('../logger'); // Import Winston logger

// Create a new task
async function createTask(req, res) {
    try {
        const { project_id, stage_id, task_name, description, due_date, priority } = req.body;
        const userId = req.user.id;

        logger.info(`User ${userId} is creating a task in project ${project_id}, stage ${stage_id} with data: ${JSON.stringify(req.body)}`);

        const project = await Project.findByPk(project_id);
        if (!project) {
            logger.warn(`Project not found: project_id=${project_id}`);
            return res.status(400).json({ error: "Project not found." });
        }

        const stage = await Stage.findOne({ where: { stage_id, project_id } });
        if (!stage) {
            logger.warn(`Stage not found or does not belong to project: stage_id=${stage_id}, project_id=${project_id}`);
            return res.status(400).json({ error: "Stage not found for the given project." });
        }

        const finalDueDate = due_date && due_date.trim() !== '' ? due_date : null;

        const task = await Task.create({
            project_id,
            stage_id,
            task_name,
            description,
            due_date: finalDueDate,
            priority,
            owner_id: userId,
        });

        logger.info(`Task created successfully: ${task.task_id} by user_id: ${userId}`);
        res.status(201).json({ message: 'Task created successfully', task });
    } catch (error) {
        logger.error(`Error in createTask: ${error.message}`, error);
        res.status(500).json({ error: 'Error creating task' });
    }
}

// Retrieve a specific task
async function getTaskById(req, res) {
    try {
        const { task_id } = req.params;
        const userId = req.user.id;

        logger.info(`User ${userId} is fetching task with ID: ${task_id}`);

        const parsedTaskId = parseInt(task_id, 10);
        if (isNaN(parsedTaskId)) {
            logger.warn(`Invalid task_id: ${task_id}`);
            return res.status(400).json({ error: "Invalid task_id. Must be an integer." });
        }

        const task = await Task.findByPk(parsedTaskId, {
            include: [
                {
                    model: User,
                    as: 'assigned_users',
                    attributes: ['user_id'],
                    through: { attributes: ['can_view', 'can_edit'] }
                }
            ]
        });

        if (!task) {
            logger.warn(`Task not found: ${parsedTaskId}`);
            return res.status(404).json({ error: 'Task not found' });
        }

        const hasFullAccess = (task.owner_id === userId) ||
            (task.assigned_users && task.assigned_users.some(u => u.user_id === userId));

        const responseData = hasFullAccess ? task : { task_name: task.task_name, is_completed: task.is_completed };

        logger.info(`Task retrieved successfully: ${parsedTaskId} for user ${userId}`);
        res.status(200).json(responseData);
    } catch (error) {
        logger.error(`Error in getTaskById: ${error.message}`, error);
        res.status(500).json({ error: 'Error retrieving task' });
    }
}

// GET all tasks for which you are assigned or owner
async function getTasksByUser(req, res) {
    try {
        const userId = req.user.id;
        logger.info(`Fetching all tasks for user: ${userId}`);

        const tasks = await Task.findAll({
            where: {
                [Op.or]: [
                    { owner_id: userId },
                    { '$assigned_users.user_id$': userId }
                ]
            },
            include: [
                {
                    model: User,
                    as: 'assigned_users',
                    attributes: ['user_id'],
                    through: {
                        attributes: ['can_view', 'can_edit'],
                    }
                }
            ]
        });

        logger.info(`Tasks retrieved for user ${userId}: ${tasks.length}`);
        res.status(200).json(tasks);
    } catch (error) {
        logger.error(`Error in getTasksByUser: ${error.message}`, error);
        res.status(500).json({ error: 'Error fetching tasks' });
    }
}

// Update task
async function updateTask(req, res) {
    try {
        const { task_id } = req.params;
        const userId = req.user.id;
        const { project_id, stage_id, task_name, description, due_date, priority, is_completed } = req.body;

        const parsedTaskId = parseInt(task_id, 10);
        if (isNaN(parsedTaskId)) {
            logger.warn(`Invalid task_id provided: ${task_id}`);
            return res.status(400).json({ error: 'Invalid task_id. Must be an integer.' });
        }

        logger.info(`User ${userId} is attempting to update task_id: ${parsedTaskId} with data: ${JSON.stringify(req.body)}`);

        const task = await Task.findOne({
            where: {
                task_id: parsedTaskId,
                [Op.or]: [
                    { owner_id: userId },
                    {
                        '$assigned_users.TaskAssignment.can_edit$': true,
                        '$assigned_users.user_id$': userId
                    }
                ]
            },
            include: [
                {
                    model: User,
                    as: 'assigned_users',
                    attributes: ['user_id'],
                    through: { attributes: ['can_edit'] }
                }
            ]
        });

        if (!task) {
            logger.warn(`Task not found or insufficient permissions for task_id: ${parsedTaskId}`);
            return res.status(404).json({ error: 'Task not found or insufficient permissions' });
        }

        if (project_id || stage_id) {
            const parsedProjectId = project_id ? parseInt(project_id, 10) : task.project_id;
            const parsedStageId = stage_id ? parseInt(stage_id, 10) : task.stage_id;

            if (isNaN(parsedProjectId) || isNaN(parsedStageId)) {
                logger.warn(`Invalid project_id: ${project_id} or stage_id: ${stage_id}`);
                return res.status(400).json({ error: "Invalid project_id or stage_id. Both must be integers." });
            }

            const project = await Project.findByPk(parsedProjectId);
            if (!project) {
                logger.warn(`Project not found: project_id=${parsedProjectId}`);
                return res.status(400).json({ error: "Project not found." });
            }

            const stage = await Stage.findOne({ where: { stage_id: parsedStageId, project_id: parsedProjectId } });
            if (!stage) {
                logger.warn(`Stage not found or does not belong to project: stage_id=${parsedStageId}, project_id=${parsedProjectId}`);
                return res.status(400).json({ error: "Stage not found for the given project." });
            }

            task.project_id = parsedProjectId;
            task.stage_id = parsedStageId;
        }

        if (task_name !== undefined) task.task_name = task_name;
        if (description !== undefined) task.description = description;
        if (due_date !== undefined) task.due_date = due_date;
        if (priority !== undefined) task.priority = priority;
        if (is_completed !== undefined) task.is_completed = is_completed;

        await task.save();

        logger.info(`Task updated successfully: ${parsedTaskId} by user_id: ${userId}`);
        res.status(200).json({ message: 'Task updated successfully', task });
    } catch (error) {
        logger.error(`Error in updateTask: ${error.message}`, error);
        res.status(500).json({ error: 'Error updating task' });
    }
}

// Delete task
async function deleteTask(req, res) {
    try {
        const { task_id } = req.params;
        const userId = req.user.id;

        const parsedTaskId = parseInt(task_id, 10);
        if (isNaN(parsedTaskId)) {
            logger.warn(`Invalid task_id provided: ${task_id}`);
            return res.status(400).json({ error: 'Invalid task_id. Must be an integer.' });
        }

        logger.info(`User ${userId} is attempting to delete task_id: ${parsedTaskId}`);

        const task = await Task.findOne({
            where: {
                task_id: parsedTaskId,
                [Op.or]: [
                    { owner_id: userId },
                    {
                        '$assigned_users.TaskAssignment.can_edit$': true,
                        '$assigned_users.user_id$': userId
                    }
                ]
            },
            include: [
                {
                    model: User,
                    as: 'assigned_users',
                    attributes: ['user_id'],
                    through: { attributes: ['can_edit'] }
                }
            ]
        });

        if (!task) {
            logger.warn(`Task not found or insufficient permissions for task_id: ${parsedTaskId}`);
            return res.status(404).json({ error: 'Task not found or insufficient permissions' });
        }

        await task.destroy();
        logger.info(`Task deleted successfully: ${parsedTaskId} by user_id: ${userId}`);
        res.status(200).json({ message: 'Task deleted successfully' });
    } catch (error) {
        logger.error(`Error in deleteTask: ${error.message}`, error);
        res.status(500).json({ error: 'Error deleting task' });
    }
}

module.exports = { createTask, getTaskById, updateTask, deleteTask, getTasksByUser };