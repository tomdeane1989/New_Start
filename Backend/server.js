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


// Middleware for JSON parsing
app.use(express.json());

// **Apply the requestLogger middleware here**
app.use(requestLogger);

// CORS configuration
app.use(cors({
    origin: 'http://localhost:3000', // Allow requests from React app
    methods: ['GET', 'POST', 'PUT', 'DELETE'], // Allowed HTTP methods
    allowedHeaders: ['Content-Type', 'Authorization'], // Allowed headers
    credentials: true, // Allow credentials (if needed)
}));

app.options('*', cors());

// Log loaded routes using Winston
logger.info(`Loaded Routes: ${JSON.stringify(routes)}`);

// Route definitions
app.use(routes.user, userRoutes); // User routes without authentication
app.use(routes.project, authMiddleware, projectRoutes); // Protect project routes
app.use(routes.task, authMiddleware, taskRoutes); // Protect task routes
app.use(routes.company, authMiddleware, companyRoutes); // Protect company routes
app.use('/api/auth', authRoutes); // Authentication routes without requiring authentication

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
1. CORS is correctly configured to allow requests from the React frontend.
2. Authentication middleware protects project, task, and company routes.
3. Centralized error handling middleware is implemented for consistent error responses.
4. Database synchronization uses `alter: true`, which modifies the database to match models. For production, consider using migrations.
5. All routes are correctly loaded and logged using Winston.
*/