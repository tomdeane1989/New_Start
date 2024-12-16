const express = require('express');
const router = express.Router();
const {
    createUser,
    getAllUsers,
    getUserById,
    updateUser,
    deleteUser,
    getUserDetails,
} = require('../controllers/userController');
const authMiddleware = require('../middleware/authMiddleware');

console.log('Initializing User Routes');

// Allow unauthenticated access to registration
router.post('/create', createUser);

// Apply middleware to protect all other routes
router.use(authMiddleware);

router.get('/getAll', getAllUsers);
router.get('/me', getUserDetails); // New route for current user details
router.get('/:id', getUserById);
router.put('/:id', updateUser);
router.delete('/:id', deleteUser);

module.exports = router;