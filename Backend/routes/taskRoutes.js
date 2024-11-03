const express = require('express');
const router = express.Router();
const { getTasksByUser, getTaskById, updateTask, deleteTask, createTask } = require('../controllers/taskController');
const { isAuthenticated } = require('../middleware/authMiddleware');  // Use central authentication middleware

// Apply authentication to all task routes
router.use(isAuthenticated);

// Define CRUD routes for tasks
router.post('/', createTask);
router.get('/user-tasks', getTasksByUser);  // Route to get all tasks associated with a user
router.get('/:task_id', getTaskById);
router.put('/:task_id', updateTask);
router.delete('/:task_id', deleteTask);

module.exports = router;


