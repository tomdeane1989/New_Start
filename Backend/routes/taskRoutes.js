// Backend/routes/taskRoutes.js
const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/authMiddleware');
const validateTask = require('../middleware/validateTask');
const {
  createTask,
  getTaskById,
  getTasksByUser,
  updateTask,
  deleteTask,
  markTaskAsCompleted,
  approveAssignee, // <--- new
} = require('../controllers/taskController');

router.use(authMiddleware);

router.post('/', validateTask, createTask);
router.get('/user-tasks', getTasksByUser);
router.get('/:task_id', getTaskById);
router.put('/:task_id', validateTask, updateTask);
router.delete('/:task_id', deleteTask);
router.put('/:id/complete', markTaskAsCompleted);

// APPROVE route
router.put('/:task_id/assignments/:assignment_id/approve', approveAssignee);

module.exports = router;