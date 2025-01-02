// Backend/controllers/authController.js

const bcrypt = require('bcrypt');
const { User } = require('../models');
const { validationResult } = require('express-validator'); // Correct import
const jwt = require('jsonwebtoken');
const logger = require('../logger'); // Ensure logger is correctly imported

const JWT_SECRET = process.env.JWT_SECRET;

// Ensure JWT_SECRET is defined
if (!JWT_SECRET) {
    logger.error('JWT_SECRET is not defined in environment variables.');
    throw new Error('JWT_SECRET environment variable is required.');
}

exports.loginUser = async (req, res) => {
    try {
        // Extract validation errors from the request
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            logger.warn(`Login validation failed: ${JSON.stringify(errors.array())}`);
            return res.status(400).json({ errors: errors.array() });
        }

        const { email, password } = req.body;

        // Normalize email to lowercase to ensure case-insensitive matching
        const normalizedEmail = email.toLowerCase();

        // Find user by email
        const user = await User.findOne({ where: { email: normalizedEmail } });
        if (!user) {
            logger.warn(`Login failed: User not found with email=${normalizedEmail}`);
            return res.status(400).json({ error: 'Invalid email or password.' });
        }

        // Validate password using bcrypt
        const isValid = await bcrypt.compare(password, user.password_hash);
        if (!isValid) {
            logger.warn(`Login failed: Invalid password for email=${normalizedEmail}`);
            return res.status(400).json({ error: 'Invalid email or password.' });
        }

        // Generate JWT Token
        const token = jwt.sign(
            { id: user.user_id, email: user.email },
            JWT_SECRET,
            { expiresIn: '1h' }
        );

        logger.info(`User logged in successfully: user_id=${user.user_id}`);
        res.status(200).json({ token });
    } catch (error) {
        logger.error(`Error during login: ${error.message}`);
        res.status(500).json({ error: 'Internal server error.' });
    }
};