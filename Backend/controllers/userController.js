const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../models');
const { User, Company } = db;
const logger = require('../logger'); // Import Winston logger

const JWT_SECRET = process.env.JWT_SECRET || 'your_secret_key'; // Use environment variable

// Controller function to create a user
// Backend/controllers/userController.js

// Controller function to create a user
const createUser = async (req, res) => {
    try {
        const { username, email, password } = req.body;

        if (!username || !email || !password) {
            logger.warn('Missing required fields: username, email, or password');
            return res.status(400).json({ error: 'Missing required fields: username, email, or password' });
        }

        logger.info(`Creating user: ${email}`);

        // Create the user without manually hashing the password
        const newUser = await User.create({
            username,
            email,
            password_hash: password, // Pass plaintext password; model's hook will hash it
        });

        logger.info(`User created successfully: user_id=${newUser.user_id}`);
        res.status(201).json({ message: 'User created successfully', user: newUser });
    } catch (error) {
        logger.error(`Error creating user: ${error.message}`);
        res.status(500).json({ error: 'Failed to create user', details: error.message });
    }
};

module.exports = { createUser };

// Controller function to retrieve all users
const getAllUsers = async (req, res) => {
    try {
        logger.info('Request received at /getAll');

        const users = await User.findAll({
            include: {
                model: Company,
                as: 'company',
                attributes: ['company_id', 'company_name'], // Include company details
            },
        });

        if (!users.length) {
            logger.warn('No users found in the database.');
            return res.status(404).json({ message: 'No users found' });
        }

        logger.info(`Users retrieved successfully: ${users.length} users found.`);
        res.status(200).json({ message: 'Users retrieved successfully', users });
    } catch (error) {
        logger.error(`Error retrieving users: ${error.message}`, error);
        res.status(500).json({ error: 'Failed to retrieve users', details: error.message });
    }
};

// Get user by ID
const getUserById = async (req, res) => {
    try {
        const { id } = req.params;
        logger.info(`Fetching user with ID: ${id}`);

        const user = await User.findByPk(id, {
            include: {
                model: Company,
                as: 'company',
                attributes: ['company_id', 'company_name'], // Include company details
            },
        });

        if (!user) {
            logger.warn(`User with ID ${id} not found`);
            return res.status(404).json({ error: 'User not found' });
        }

        logger.info(`User retrieved successfully: ${id}`);
        res.status(200).json(user);
    } catch (error) {
        logger.error(`Error in getUserById: ${error.message}`, error);
        res.status(500).json({ error: 'Failed to retrieve user', details: error.message });
    }
};

// Get a user by token
const getUserDetails = async (req, res) => {
    try {
        const userId = req.user.id; // Extract the user ID from the token (authMiddleware adds `req.user`)
        logger.info(`Fetching user details for user ID: ${userId}`);

        const user = await User.findByPk(userId, {
            attributes: ['user_id', 'username', 'email', 'first_name', 'last_name', 'company_id'], // Select relevant fields
            include: {
                model: Company,
                as: 'company',
                attributes: ['company_id', 'company_name'], // Include company details if needed
            },
        });

        if (!user) {
            logger.warn(`User with ID ${userId} not found`);
            return res.status(404).json({ error: 'User not found' });
        }

        logger.info(`User details retrieved successfully for user ID: ${userId}`);
        res.status(200).json(user);
    } catch (error) {
        logger.error(`Error in getUserDetails: ${error.message}`, error);
        res.status(500).json({ error: 'Failed to fetch user details' });
    }
};

// Controller function to update a user by ID
const updateUser = async (req, res) => {
    try {
        const { id } = req.params;
        logger.info(`Request received to update user with ID: ${id} and body: ${JSON.stringify(req.body)}`);

        const { company_id, company_name, ...updateFields } = req.body;

        const user = await User.findByPk(id);

        if (!user) {
            logger.warn(`User with ID ${id} not found for update.`);
            return res.status(404).json({ message: `User with ID ${id} not found` });
        }

        // Handle company association updates
        let companyId = company_id || user.company_id;

        if (company_name) {
            const existingCompany = await Company.findOne({ where: { company_name } });
            if (existingCompany) {
                companyId = existingCompany.company_id;
                logger.info(`Using existing company: ${company_name} with ID: ${companyId}`);
            } else {
                const newCompany = await Company.create({ company_name });
                companyId = newCompany.company_id;
                logger.info(`Created new company: ${company_name} with ID: ${companyId}`);
            }
        }

        const updatedUser = await user.update({ ...updateFields, company_id: companyId });

        logger.info(`User updated successfully: ${id}`);
        res.status(200).json({ message: 'User updated successfully', user: updatedUser });
    } catch (error) {
        logger.error(`Error updating user: ${error.message}`, error);
        res.status(500).json({ error: 'Failed to update user', details: error.message });
    }
};

// Controller function to delete a user by ID
const deleteUser = async (req, res) => {
    try {
        const { id } = req.params;
        logger.info(`Request received to delete user with ID: ${id}`);

        const user = await User.findByPk(id);

        if (!user) {
            logger.warn(`User with ID ${id} not found for deletion.`);
            return res.status(404).json({ message: `User with ID ${id} not found` });
        }

        await user.destroy();
        logger.info(`User with ID ${id} deleted successfully.`);
        res.status(200).json({ message: `User with ID ${id} deleted successfully` });
    } catch (error) {
        logger.error(`Error deleting user: ${error.message}`, error);
        res.status(500).json({ error: 'Failed to delete user', details: error.message });
    }
};

module.exports = {
    createUser,
    getAllUsers,
    getUserById,
    updateUser,
    deleteUser,
    getUserDetails,
};