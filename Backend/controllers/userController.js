const { User } = require('../models'); // Ensure it pulls from db object
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Register a new user
async function createUser(req, res) {
    console.log('Request body:', req.body);  // Log request data for debugging
    try {
        const { username, email, password, role, first_name, last_name } = req.body;
        const password_hash = await bcrypt.hash(password, 10);
        const user = await User.create({ username, email, password_hash, role, first_name, last_name });
        res.status(201).json({ message: 'User created successfully', user });
    } catch (error) {
        console.error('Error in createUser:', error);  // Log specific error
        res.status(500).json({ error: 'Error creating user' });
    }
}

// Get a master list of all users
async function getAllUsers(req, res) {
    try {
        const users = await User.findAll(); // Fetches all user records
        res.json(users);
    } catch (error) {
        console.error("Error in getAllUsers:", error);
        res.status(500).json({ error: 'Error retrieving users' });
    }
}

// Get a single user by ID
async function getUserById(req, res) {
    try {
        const user = await User.findByPk(req.params.id);
        if (!user) return res.status(404).json({ error: 'User not found' });
        res.json(user);
    } catch (error) {
        console.error("Error in getUserById:", error);
        res.status(500).json({ error: 'Error retrieving user' });
    }
}

// Update a user by ID
async function updateUser(req, res) {
    try {
        const { id } = req.params;
        const { username, email, role, first_name, last_name } = req.body;
        const [updated] = await User.update(
            { username, email, role, first_name, last_name },
            { where: { user_id: id } }
        );
        if (!updated) return res.status(404).json({ error: 'User not found' });
        res.json({ message: 'User updated successfully' });
    } catch (error) {
        console.error("Error in updateUser:", error);
        res.status(500).json({ error: 'Error updating user' });
    }
}

// Delete a user by ID
async function deleteUser(req, res) {
    try {
        const { id } = req.params;
        const deleted = await User.destroy({ where: { user_id: id } });
        if (!deleted) return res.status(404).json({ error: 'User not found' });
        res.json({ message: 'User deleted successfully' });
    } catch (error) {
        console.error("Error in deleteUser:", error);
        res.status(500).json({ error: 'Error deleting user' });
    }
}


// Login Route //
async function loginUser(req, res) {
    const { email, password } = req.body;
    try {
      const user = await User.findOne({ where: { email } });
      if (!user || !(await bcrypt.compare(password, user.password_hash))) {
        return res.status(401).json({ error: 'Invalid credentials' });
      }
      const token = jwt.sign({ id: user.user_id }, process.env.JWT_SECRET, { expiresIn: '1h' });
      res.json({ message: 'Login successful', token });
    } catch (error) {
      console.error('Error in loginUser:', error);
      res.status(500).json({ error: 'Error logging in' });
    }
  }

     




module.exports = { createUser, loginUser, getUserById, updateUser, deleteUser, getAllUsers };