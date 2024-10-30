// server.js
require('dotenv').config();
const express = require('express');
const app = express();
const userRoutes = require('./routes/userRoutes');
const projectRoutes = require('./routes/projectRoutes');
const { isAuthenticated } = require('./middleware/authMiddleware');
const db = require('./models'); // Import models for associations and syncing

// Middleware for JSON parsing
app.use(express.json());

// Route definitions with authentication on project routes
app.use('/api/projects', isAuthenticated, projectRoutes);
app.use('/api/users', userRoutes);

// Error handling middleware for clearer error messages
app.use((err, req, res, next) => {
    console.error('Error:', err); // Log the error for debugging
    res.status(500).json({ error: 'Server Error' });
});

// Database synchronization
db.sequelize.sync({ alter: true })
    .then(() => console.log('Database synced'))
    .catch(err => console.error('Database sync error:', err));

// Start the server
const PORT = process.env.PORT || 5001;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));