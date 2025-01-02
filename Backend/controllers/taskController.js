// Backend/controllers/taskController.js

const { Op } = require('sequelize');
const {
  Task,
  Project,
  Stage,
  TaskAssignment,
  User,
  Document,      // <-- ADDED
  TaskDocument,  // <-- ADDED
} = require('../models');
const logger = require('../logger'); // Import Winston logger

//
// HELPER FUNCTIONS
//

// Helper function to set assigned users
async function setTaskAssignments(task_id, assignedUserIds) {
  // Remove existing assignments for this task
  await TaskAssignment.destroy({ where: { task_id } });

  if (!assignedUserIds || assignedUserIds.length === 0) return;

  // Create new assignments
  const assignments = assignedUserIds.map(user_id => ({
    task_id,
    user_id,
    can_view: true,
    can_edit: false,
  }));

  await TaskAssignment.bulkCreate(assignments);
}

// Helper function to set documents (many-to-many via TaskDocument)
async function setTaskDocuments(task_id, documentIds) {
  // Remove existing references for this task
  await TaskDocument.destroy({ where: { task_id } });

  if (!documentIds || documentIds.length === 0) return;

  // Create new references
  const refs = documentIds.map(docId => ({
    task_id,
    document_id: docId,
  }));

  await TaskDocument.bulkCreate(refs);
}

//
// CONTROLLERS
//

// Create a new task
async function createTask(req, res) {
  try {
    const {
      project_id,
      stage_id,
      task_name,
      description,
      due_date,
      priority,
      assigned_users,
      documents, // ADDED: array of document IDs from the frontend
    } = req.body;
    const userId = req.user.id;

    logger.info(
      `User ${userId} is creating a task in project ${project_id}, stage ${stage_id} with data: ${JSON.stringify(
        req.body
      )}`
    );

    const project = await Project.findByPk(project_id);
    if (!project) {
      logger.warn(`Project not found: project_id=${project_id}`);
      return res.status(400).json({ error: 'Project not found.' });
    }

    const stage = await Stage.findOne({ where: { stage_id, project_id } });
    if (!stage) {
      logger.warn(
        `Stage not found or does not belong to project: stage_id=${stage_id}, project_id=${project_id}`
      );
      return res
        .status(400)
        .json({ error: 'Stage not found for the given project.' });
    }

    const finalDueDate = due_date && due_date.trim() !== '' ? due_date : null;

    // Create the core task
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

    // Assign users if any
    if (Array.isArray(assigned_users)) {
      await setTaskAssignments(task.task_id, assigned_users);
    }

    // Link documents if provided
    if (Array.isArray(documents)) {
      await setTaskDocuments(task.task_id, documents);
    }

    // Refetch the task including assigned_users and documents
    const updatedTask = await Task.findByPk(task.task_id, {
      include: [
        {
          model: User,
          as: 'assigned_users',
          attributes: ['user_id'],
          through: { attributes: ['can_view', 'can_edit'] },
        },
        {
          model: Document,
          as: 'documents',
          attributes: ['document_id', 'file_name', 'file_url', 'tags'],
          through: { attributes: [] }, // no extra join table attributes
        },
      ],
    });

    res.status(201).json({ message: 'Task created successfully', task: updatedTask });
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
      return res.status(400).json({ error: 'Invalid task_id. Must be an integer.' });
    }

    const task = await Task.findByPk(parsedTaskId, {
      include: [
        {
          model: User,
          as: 'assigned_users',
          attributes: ['user_id', 'first_name', 'last_name', 'email'],
          through: {
            attributes: ['can_view', 'can_edit'],
          },
        },
        {
          model: User,
          as: 'owner',
          attributes: ['user_id', 'first_name', 'last_name', 'email'],
        },
        {
          model: Stage,
          as: 'stage',
          attributes: ['stage_id', 'stage_name'],
        },
        {
          model: Project,
          as: 'project',
          attributes: ['project_id', 'project_name'],
        },
        // ADD documents if you want them in the single-task fetch
        {
          model: Document,
          as: 'documents',
          attributes: ['document_id', 'file_name', 'file_url', 'tags'],
          through: { attributes: [] },
        },
      ],
    });

    if (!task) {
      logger.warn(`Task not found: ${parsedTaskId}`);
      return res.status(404).json({ error: 'Task not found' });
    }

    const hasFullAccess =
      task.owner_id === userId ||
      (task.assigned_users && task.assigned_users.some(u => u.user_id === userId));

    // If user isn't the owner/assignee, restrict data
    const responseData = hasFullAccess
      ? task
      : { task_name: task.task_name, is_completed: task.is_completed };

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
        [Op.or]: [{ owner_id: userId }, { '$assigned_users.user_id$': userId }],
      },
      include: [
        {
          model: User,
          as: 'assigned_users',
          attributes: ['user_id'],
          through: {
            attributes: ['can_view', 'can_edit'],
          },
        },
        {
          model: Stage,
          as: 'stage',
          attributes: ['stage_id', 'stage_name', 'stage_order', 'is_custom'],
        },
        {
          model: Project,
          as: 'project',
          attributes: ['project_id', 'project_name'],
        },
      ],
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
    const {
      project_id,
      stage_id,
      task_name,
      description,
      due_date,
      priority,
      is_completed,
      assigned_users,
      documents, // ADDED: array of doc IDs
    } = req.body;

    const parsedTaskId = parseInt(task_id, 10);
    if (isNaN(parsedTaskId)) {
      logger.warn(`Invalid task_id provided: ${task_id}`);
      return res.status(400).json({ error: 'Invalid task_id. Must be an integer.' });
    }

    logger.info(
      `User ${userId} is attempting to update task_id: ${parsedTaskId} with data: ${JSON.stringify(
        req.body
      )}`
    );

    const task = await Task.findOne({
      where: {
        task_id: parsedTaskId,
        [Op.or]: [
          { owner_id: userId },
          {
            '$assigned_users.TaskAssignment.can_edit$': true,
            '$assigned_users.user_id$': userId,
          },
        ],
      },
      include: [
        {
          model: User,
          as: 'assigned_users',
          attributes: ['user_id'],
          through: { attributes: ['can_edit'] },
        },
      ],
    });

    if (!task) {
      logger.warn(
        `Task not found or insufficient permissions for task_id: ${parsedTaskId}`
      );
      return res
        .status(404)
        .json({ error: 'Task not found or insufficient permissions' });
    }

    // If project_id/stage_id changed, validate them
    if (project_id || stage_id) {
      const parsedProjectId = project_id ? parseInt(project_id, 10) : task.project_id;
      const parsedStageId = stage_id ? parseInt(stage_id, 10) : task.stage_id;

      if (isNaN(parsedProjectId) || isNaN(parsedStageId)) {
        logger.warn(`Invalid project_id: ${project_id} or stage_id: ${stage_id}`);
        return res
          .status(400)
          .json({ error: 'Invalid project_id or stage_id. Both must be integers.' });
      }

      const project = await Project.findByPk(parsedProjectId);
      if (!project) {
        logger.warn(`Project not found: project_id=${parsedProjectId}`);
        return res.status(400).json({ error: 'Project not found.' });
      }

      const stage = await Stage.findOne({
        where: { stage_id: parsedStageId, project_id: parsedProjectId },
      });
      if (!stage) {
        logger.warn(
          `Stage not found or does not belong to project: stage_id=${parsedStageId}, project_id=${parsedProjectId}`
        );
        return res
          .status(400)
          .json({ error: 'Stage not found for the given project.' });
      }

      task.project_id = parsedProjectId;
      task.stage_id = parsedStageId;
    }

    // Update fields
    if (task_name !== undefined) task.task_name = task_name;
    if (description !== undefined) task.description = description;
    if (due_date !== undefined) task.due_date = due_date;
    if (priority !== undefined) task.priority = priority;
    if (is_completed !== undefined) task.is_completed = is_completed;

    await task.save();

    // Update assigned_users if provided
    if (Array.isArray(assigned_users)) {
      await setTaskAssignments(task.task_id, assigned_users);
    }

    // Update documents if provided
    if (Array.isArray(documents)) {
      await setTaskDocuments(task.task_id, documents);
    }

    // Refetch the updated task with assigned_users and documents
    const updatedTask = await Task.findByPk(task.task_id, {
      include: [
        {
          model: User,
          as: 'assigned_users',
          attributes: ['user_id'],
          through: { attributes: ['can_view', 'can_edit'] },
        },
        {
          model: Document,
          as: 'documents',
          attributes: ['document_id', 'file_name', 'file_url', 'tags'],
          through: { attributes: [] },
        },
      ],
    });

    logger.info(`Task updated successfully: ${parsedTaskId} by user_id: ${userId}`);
    res.status(200).json({ message: 'Task updated successfully', task: updatedTask });
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
      return res
        .status(400)
        .json({ error: 'Invalid task_id. Must be an integer.' });
    }

    logger.info(`User ${userId} is attempting to delete task_id: ${parsedTaskId}`);

    const task = await Task.findOne({
      where: {
        task_id: parsedTaskId,
        [Op.or]: [
          { owner_id: userId },
          {
            '$assigned_users.TaskAssignment.can_edit$': true,
            '$assigned_users.user_id$': userId,
          },
        ],
      },
      include: [
        {
          model: User,
          as: 'assigned_users',
          attributes: ['user_id'],
          through: { attributes: ['can_edit'] },
        },
      ],
    });

    if (!task) {
      logger.warn(
        `Task not found or insufficient permissions for task_id: ${parsedTaskId}`
      );
      return res
        .status(404)
        .json({ error: 'Task not found or insufficient permissions' });
    }

    await task.destroy();
    logger.info(`Task deleted successfully: ${parsedTaskId} by user_id: ${userId}`);
    res.status(200).json({ message: 'Task deleted successfully' });
  } catch (error) {
    logger.error(`Error in deleteTask: ${error.message}`, error);
    res.status(500).json({ error: 'Error deleting task' });
  }
}

// Mark task as completed
async function markTaskAsCompleted(req, res) {
  try {
    const { id: task_id } = req.params; // 'id' is the task_id
    const userId = req.user.id;

    const parsedTaskId = parseInt(task_id, 10);
    if (isNaN(parsedTaskId)) {
      logger.warn(`Invalid task_id: ${task_id}`);
      return res.status(400).json({ error: 'Invalid task ID' });
    }

    logger.info(`User ${userId} is attempting to mark task ${parsedTaskId} as completed.`);

    const task = await Task.findOne({
      where: { task_id: parsedTaskId },
      include: [
        {
          model: TaskAssignment,
          as: 'taskAssignments',
          where: { user_id: userId },
          required: false,
        },
        {
          model: Project,
          as: 'project',
          attributes: ['project_id', 'project_name'],
        },
        {
          model: Stage,
          as: 'stage',
          attributes: ['stage_id', 'stage_name'],
        },
      ],
    });

    if (!task) {
      logger.warn(`Task not found: task_id=${parsedTaskId}`);
      return res.status(404).json({ error: 'Task not found' });
    }

    // Check if user is owner or assigned to the task
    const isOwner = task.owner_id === userId;
    const isAssigned = task.taskAssignments && task.taskAssignments.length > 0;

    if (!isOwner && !isAssigned) {
      logger.warn(
        `User ${userId} is not authorized to mark task ${parsedTaskId} as completed.`
      );
      return res.status(403).json({
        error: 'You do not have permission to complete this task',
      });
    }

    // Mark as completed
    task.is_completed = true;
    await task.save();

    logger.info(`Task ${parsedTaskId} marked as completed by user ${userId}`);
    res.status(200).json({ message: 'Task marked as completed', task });
  } catch (error) {
    logger.error(`Error in markTaskAsCompleted: ${error.message}`, error);
    res.status(500).json({ error: 'Error marking task as completed' });
  }
}

module.exports = {
  createTask,
  getTaskById,
  getTasksByUser,
  updateTask,
  deleteTask,
  markTaskAsCompleted,
};