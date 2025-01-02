// Backend/models/index.js

const fs = require('fs');
const path = require('path');
const Sequelize = require('sequelize');
const basename = path.basename(__filename);
const env = process.env.NODE_ENV || 'development';
const config = require('../config/config.json')[env];
const db = {};

let sequelize;
if (config.use_env_variable) {
  sequelize = new Sequelize(process.env[config.use_env_variable], config);
} else {
  sequelize = new Sequelize(config.database, config.username, config.password, config);
}

// Load models dynamically
fs
  .readdirSync(__dirname)
  .filter(file => {
    return (
      file.indexOf('.') !== 0 &&
      file !== basename &&
      file.slice(-3) === '.js'
    );
  })
  .forEach(file => {
    try {
      const model = require(path.join(__dirname, file))(sequelize, Sequelize.DataTypes);
      db[model.name] = model;
      console.log(`Model loaded: ${model.name}`);
    } catch (error) {
      console.error(`Failed to load model from file: ${file}`, error);
    }
  });

// Initialize associations
Object.keys(db).forEach(modelName => {
  if (db[modelName].associate) {
    try {
      db[modelName].associate(db);
      console.log(`Associations initialized for model: ${modelName}`);
    } catch (error) {
      console.error(`Failed to initialize associations for model: ${modelName}`, error);
    }
  }
});

// Test model availability
const requiredModels = ['Project', 'User', 'Company', 'Task', 'TaskAssignment'];
requiredModels.forEach((modelName) => {
    if (!db[modelName]) {
        console.error(`Required model not found: ${modelName}. Please verify the model file.`);
    } else {
        console.log(`Model verified: ${modelName}`);
    }
});

db.sequelize = sequelize;
db.Sequelize = Sequelize;

module.exports = db;