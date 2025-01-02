// Backend/routes/taskRoutes.js
const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/authMiddleware');
const validateTask = require('../middleware/validateTask');
const taskController = require('../controllers/taskController'); // Import taskController

const { 
    getTasksByUser, 
    getTaskById, 
    updateTask, 
    deleteTask, 
    createTask,
    markTaskAsCompleted 
} = taskController;

// Protect all task routes
router.use(authMiddleware);

// Define CRUD routes for tasks with validation where necessary
router.post('/', validateTask, createTask);     // Create a new task
router.get('/user-tasks', getTasksByUser);      // Get all tasks associated with a user
router.get('/:task_id', getTaskById);           // Get a specific task by ID
router.put('/:task_id', validateTask, updateTask);  // Update a task by ID
router.delete('/:task_id', deleteTask);         // Delete a task by ID

// Add route to mark task as completed
router.put('/:id/complete', markTaskAsCompleted);

// Removed the incorrect 'assigned' route
// router.get('/assigned', authMiddleware, taskController.getAssignedTasks);//Get all open tasks assigned to the authenticated user

module.exports = router;