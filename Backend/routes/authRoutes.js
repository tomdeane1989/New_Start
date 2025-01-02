// Backend/routes/authRoutes.js

const express = require('express');
const router = express.Router();
const { loginUser } = require('../controllers/authController');
const { body } = require('express-validator');

// Login Route
router.post(
  '/login',
  [
    body('email').isEmail().withMessage('Valid email is required.'),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters long.'),
  ],
  loginUser
);

module.exports = router;