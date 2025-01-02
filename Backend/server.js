// Backend/server.js

require('dotenv').config();
const express = require('express');
require('express-async-errors');
const cors = require('cors'); // Import CORS
const app = express();
const userRoutes = require('./routes/userRoutes');
const projectRoutes = require('./routes/projectRoutes');
const taskRoutes = require('./routes/taskRoutes');
const companyRoutes = require('./routes/companyRoutes');
const authRoutes = require('./routes/authRoutes'); // Add auth routes
const authMiddleware = require('./middleware/authMiddleware'); // Correct path and usage
const db = require('./models'); // Models for associations
const routes = require('./config/routeConfig');
const logger = require('./logger'); // Import Winston logger
const errorHandler = require('./middleware/errorHandler'); // Import centralized error handler
const requestLogger = require('./middleware/requestLogger'); // Import the requestLogger middleware
const documentRoutes = require('./routes/documentRoutes');
const path = require('path'); // For serving static files

// Middleware for JSON parsing
app.use(express.json());

// Apply the requestLogger middleware
app.use(requestLogger);

// CORS configuration
app.use(cors({
    origin: 'http://localhost:3000', // Allow requests from your React app
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
}));
app.options('*', cors());

// Log loaded routes using Winston
logger.info(`Loaded Routes: ${JSON.stringify(routes)}`);

// Ensure we serve /uploads from this backend on port 5001
// So requests to http://localhost:5001/uploads/<filename> retrieve the file
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Route definitions
app.use(routes.user, userRoutes);
app.use(routes.project, authMiddleware, projectRoutes);
app.use(routes.task, authMiddleware, taskRoutes);
app.use(routes.company, authMiddleware, companyRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/documents', documentRoutes);

// Example protected route
app.get('/api/protected', authMiddleware, (req, res) => {
    logger.info(`Accessing protected route for user: ${JSON.stringify(req.user)}`);
    res.status(200).json({ message: 'You have accessed a protected route', user: req.user });
});

// Database synchronization
db.sequelize.sync({ alter: true })
    .then(() => logger.info('Database synced successfully'))
    .catch(err => logger.error('Database sync error:', err));

// Use the centralized error handling middleware (should be after all routes)
app.use(errorHandler);

// Start the server
const PORT = process.env.PORT || 5001;
app.listen(PORT, () => logger.info(`Server running on port ${PORT}`));

/*
Notes:
1. CORS is set to allow requests from localhost:3000.
2. /uploads is now served at http://localhost:5001/uploads/<filename>.
3. Make sure your Document records have file_url = "http://localhost:5001/uploads/..."
*/