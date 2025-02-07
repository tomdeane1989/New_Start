// Backend/controllers/taskController.js

const { Op } = require('sequelize');
const {
  Task,
  Project,
  Stage,
  TaskAssignment,
  User,
  Document,
  TaskDocument,
} = require('../models');
const logger = require('../logger');

/**
 * HELPER: setTaskAssignments
 * 
 * Now expects an array of objects: [{ user_id, can_edit }, ...].
 * We default can_edit to true if not provided.
 * We also set awaiting_approval = false if you want auto-approval.
 */
async function setTaskAssignments(task_id, assigned) {
  // Clear old assignments
  await TaskAssignment.destroy({ where: { task_id } });
  if (!Array.isArray(assigned) || assigned.length === 0) return;

  const newAssignments = assigned.map((item) => {
    return {
      task_id,
      user_id: item.user_id,
      can_view: true, // always true
      can_edit: (typeof item.can_edit === 'boolean') ? item.can_edit : true,
      awaiting_approval: false, // auto-approve now
    };
  });

  await TaskAssignment.bulkCreate(newAssignments);
}

/**
 * HELPER: setTaskDocuments
 */
async function setTaskDocuments(task_id, documentIds) {
  await TaskDocument.destroy({ where: { task_id } });
  if (!Array.isArray(documentIds) || documentIds.length === 0) return;

  const refs = documentIds.map(docId => ({
    task_id,
    document_id: docId,
  }));
  await TaskDocument.bulkCreate(refs);
}

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
      documents,
    } = req.body;
    const userId = req.user.id;

    logger.info(
      `User ${userId} is creating a task in project ${project_id}, stage ${stage_id}`
    );

    // Validate project and stage
    const project = await Project.findByPk(project_id);
    if (!project) {
      logger.warn(`Project not found: project_id=${project_id}`);
      return res.status(400).json({ error: 'Project not found.' });
    }

    const stage = await Stage.findOne({ where: { stage_id, project_id } });
    if (!stage) {
      logger.warn(`Stage not found or not in project: stage_id=${stage_id}, project_id=${project_id}`);
      return res.status(400).json({ error: 'Stage not found for the given project.' });
    }

    const finalDueDate = due_date && due_date.trim() !== '' ? due_date : null;

    // Create the Task
    const task = await Task.create({
      project_id,
      stage_id,
      task_name,
      description,
      due_date: finalDueDate,
      priority,
      owner_id: userId,
    });

    logger.info(`Task created: ${task.task_id} by user_id: ${userId}`);

    // Assign users if provided
    if (Array.isArray(assigned_users)) {
      await setTaskAssignments(task.task_id, assigned_users);
    }

    // Link documents if any
    if (Array.isArray(documents)) {
      await setTaskDocuments(task.task_id, documents);
    }

    // Refetch
    const updatedTask = await Task.findByPk(task.task_id, {
      include: [
        {
          model: User,
          as: 'assigned_users',
          attributes: ['user_id', 'first_name', 'last_name', 'email'],
          through: {
            attributes: ['can_view', 'can_edit', 'awaiting_approval', 'assignment_id'],
          },
        },
        {
          model: Document,
          as: 'documents',
          attributes: ['document_id', 'file_name', 'file_url', 'tags'],
          through: { attributes: [] },
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

    logger.info(`User ${userId} fetching task_id=${task_id}`);

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
            attributes: ['can_view', 'can_edit', 'awaiting_approval', 'assignment_id'],
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
          attributes: ['project_id', 'project_name', 'owner_id'],
        },
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

    // Check project if user is a collaborator or project owner
    const isProjectOwner = (task.project && task.project.owner_id === userId);
    // Check if user is assigned
    const isAssigned = task.assigned_users && task.assigned_users.some(u => u.user_id === userId);

    if (!isProjectOwner && !isAssigned) {
      logger.warn(`User ${userId} does not have access to task ${parsedTaskId}.`);
      return res.status(403).json({ error: 'Insufficient permissions to view this task' });
    }

    logger.info(`Task retrieved successfully: ${parsedTaskId} for user ${userId}`);
    res.status(200).json(task);
  } catch (error) {
    logger.error(`Error in getTaskById: ${error.message}`, error);
    res.status(500).json({ error: 'Error retrieving task' });
  }
}

// GET all tasks for which you are assigned or owner
async function getTasksByUser(req, res) {
  try {
    const userId = req.user.id;
    logger.info(`Fetching tasks for user: ${userId}`);

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
            attributes: ['can_view', 'can_edit', 'awaiting_approval', 'assignment_id'],
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

    logger.info(`Tasks for user ${userId}: ${tasks.length}`);
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
      documents,
    } = req.body;

    const parsedTaskId = parseInt(task_id, 10);
    if (isNaN(parsedTaskId)) {
      logger.warn(`Invalid task_id: ${task_id}`);
      return res.status(400).json({ error: 'Invalid task_id. Must be an integer.' });
    }

    logger.info(`User ${userId} update task_id=${parsedTaskId}`);

    // Only owner or can_edit = true can do this
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
      logger.warn(`Task not found or no permission: task_id=${parsedTaskId}`);
      return res.status(404).json({ error: 'Task not found or insufficient permissions' });
    }

    // Validate project/stage if present
    if (project_id || stage_id) {
      const parsedProjectId = project_id ? parseInt(project_id, 10) : task.project_id;
      const parsedStageId = stage_id ? parseInt(stage_id, 10) : task.stage_id;

      if (isNaN(parsedProjectId) || isNaN(parsedStageId)) {
        logger.warn(`Invalid project_id: ${project_id} or stage_id: ${stage_id}`);
        return res.status(400).json({ error: 'Invalid project_id or stage_id. Must be integers.' });
      }

      const project = await Project.findByPk(parsedProjectId);
      if (!project) {
        logger.warn(`Project not found: project_id=${parsedProjectId}`);
        return res.status(400).json({ error: 'Project not found.' });
      }

      const stage = await Stage.findOne({ where: { stage_id: parsedStageId, project_id: parsedProjectId } });
      if (!stage) {
        logger.warn(`Stage not found for project`);
        return res.status(400).json({ error: 'Stage not found for the given project.' });
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

    // Update assigned users
    if (Array.isArray(assigned_users)) {
      await setTaskAssignments(task.task_id, assigned_users);
    }

    // Update documents
    if (Array.isArray(documents)) {
      await setTaskDocuments(task.task_id, documents);
    }

    // Refetch
    const updatedTask = await Task.findByPk(task.task_id, {
      include: [
        {
          model: User,
          as: 'assigned_users',
          attributes: ['user_id', 'first_name', 'last_name', 'email'],
          through: {
            attributes: ['can_view', 'can_edit', 'awaiting_approval', 'assignment_id'],
          },
        },
        {
          model: Document,
          as: 'documents',
          attributes: ['document_id', 'file_name', 'file_url', 'tags'],
          through: { attributes: [] },
        },
      ],
    });

    logger.info(`Task updated successfully: ${parsedTaskId}`);
    res.status(200).json({ message: 'Task updated', task: updatedTask });
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
      logger.warn(`Invalid task_id: ${task_id}`);
      return res.status(400).json({ error: 'Invalid task_id. Must be an integer.' });
    }

    logger.info(`User ${userId} deleting task_id=${parsedTaskId}`);

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
          through: { attributes: ['can_edit'] },
        },
      ],
    });

    if (!task) {
      logger.warn(`Task not found or insufficient permissions: ${parsedTaskId}`);
      return res.status(404).json({ error: 'Task not found or insufficient permissions' });
    }

    await task.destroy();
    logger.info(`Task deleted: ${parsedTaskId}`);
    res.status(200).json({ message: 'Task deleted successfully' });
  } catch (error) {
    logger.error(`Error in deleteTask: ${error.message}`, error);
    res.status(500).json({ error: 'Error deleting task' });
  }
}

// Mark task as completed
async function markTaskAsCompleted(req, res) {
  try {
    const { id: task_id } = req.params;
    const userId = req.user.id;

    const parsedTaskId = parseInt(task_id, 10);
    if (isNaN(parsedTaskId)) {
      logger.warn(`Invalid task_id: ${task_id}`);
      return res.status(400).json({ error: 'Invalid task ID' });
    }

    logger.info(`User ${userId} marking task_id=${parsedTaskId} completed.`);

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
          attributes: ['owner_id'],
        },
      ],
    });

    if (!task) {
      logger.warn(`Task not found: ${parsedTaskId}`);
      return res.status(404).json({ error: 'Task not found' });
    }

    // Owner or assigned
    const isOwner = task.project && task.project.owner_id === userId;
    const isAssigned = task.taskAssignments && task.taskAssignments.length > 0;

    if (!isOwner && !isAssigned) {
      logger.warn(`User ${userId} has no permission to complete task ${parsedTaskId}`);
      return res.status(403).json({ error: 'No permission to complete task' });
    }

    task.is_completed = true;
    await task.save();

    logger.info(`Task ${parsedTaskId} marked as completed by user ${userId}`);
    res.status(200).json({ message: 'Task marked as completed', task });
  } catch (error) {
    logger.error(`Error in markTaskAsCompleted: ${error.message}`, error);
    res.status(500).json({ error: 'Error marking task as completed' });
  }
}

// Approve assignment (if you still use this route)
async function approveAssignee(req, res) {
  try {
    const { task_id, assignment_id } = req.params;
    const userId = req.user.id;

    logger.info(`User ${userId} approving assignment ${assignment_id} for task ${task_id}`);

    const task = await Task.findByPk(task_id, {
      include: [
        {
          model: Project,
          as: 'project',
          attributes: ['owner_id'],
        },
      ],
    });

    if (!task) {
      logger.warn(`Task not found: task_id=${task_id}`);
      return res.status(404).json({ error: 'Task not found' });
    }

    if (task.project.owner_id !== userId) {
      logger.warn(`User ${userId} is not task owner for task_id=${task_id}`);
      return res.status(403).json({ error: 'Only the project owner can approve assignees' });
    }

    const assignment = await TaskAssignment.findByPk(assignment_id);
    if (!assignment || assignment.task_id !== parseInt(task_id, 10)) {
      logger.warn(`Assignment not found or mismatch: assignment_id=${assignment_id}`);
      return res.status(404).json({ error: 'Assignment not found' });
    }

    if (!assignment.awaiting_approval) {
      logger.info(`Assignment ${assignment_id} already approved`);
      return res.status(200).json({ message: 'Assignee already approved' });
    }

    assignment.awaiting_approval = false;
    await assignment.save();

    logger.info(`Assignee ${assignment_id} approved for task ${task_id}`);
    res.status(200).json({ message: 'Assignee approved', assignment });
  } catch (error) {
    logger.error(`Error approving assignee: ${error.message}`, error);
    res.status(500).json({ error: 'Error approving assignment' });
  }
}

module.exports = {
  createTask,
  getTaskById,
  getTasksByUser,
  updateTask,
  deleteTask,
  markTaskAsCompleted,
  approveAssignee,
};