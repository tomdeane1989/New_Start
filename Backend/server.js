// server.js
require('dotenv').config();
const express = require('express');
const app = express();
const userRoutes = require('./routes/userRoutes');
const projectRoutes = require('./routes/projectRoutes');

app.use(express.json());
app.use('/api/users', userRoutes);       // User routes
app.use('/api/projects', projectRoutes); // Project routes

const PORT = process.env.PORT || 5001;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));