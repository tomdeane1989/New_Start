const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

router.post('/register', userController.createUser);
router.post('/login', userController.loginUser);  // New login route
router.get('/:id', userController.getUserById);
router.put('/:id', userController.updateUser);
router.delete('/:id', userController.deleteUser);
router.get('/', userController.getAllUsers);

module.exports = router;