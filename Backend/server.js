// server.js
require('dotenv').config();
const express = require('express');
const app = express();
const userRoutes = require('./routes/userRoutes');
const projectRoutes = require('./routes/projectRoutes');
const { isAuthenticated } = require('./middleware/authMiddleware');


app.use(express.json());
app.use('/api/projects', isAuthenticated, projectRoutes); // Assuming authentication is required for all project routes
app.use('/api/users', userRoutes);

const PORT = process.env.PORT || 5001;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));