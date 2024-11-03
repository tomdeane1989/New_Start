const fs = require('fs');
const path = require('path');
const Sequelize = require('sequelize');
const basename = path.basename(__filename);
const env = process.env.NODE_ENV || 'development';
const config = require(__dirname + '/../config/config.json')[env];
const db = {};

let sequelize;
if (config.use_env_variable) {
  sequelize = new Sequelize(process.env[config.use_env_variable], config);
} else {
  sequelize = new Sequelize(config.database, config.username, config.password, config);
}

// Load models and populate `db` object
fs.readdirSync(__dirname)
  .filter(file => file.indexOf('.') !== 0 && file !== basename && file.slice(-3) === '.js')
  .forEach(file => {
    const model = require(path.join(__dirname, file))(sequelize, Sequelize.DataTypes);
    db[model.name] = model;
  });

// Ensure models are loaded in `db`
const { Task, User, Project, Stage, taskassignment, ProjectCollaborators } = db;

// Define associations for `Task`
Task.belongsTo(Project, { foreignKey: 'project_id', as: 'project' });
Task.belongsTo(Stage, { foreignKey: 'stage_id', as: 'stage' });
Task.belongsTo(User, { foreignKey: 'owner_id', as: 'owner' });
Task.belongsToMany(User, {
  through: taskassignment,   // Updated to reference the singular taskassignment model
  foreignKey: 'task_id',
  otherKey: 'collaborator_id', // Updated to match collaborator_id in taskassignment model
  as: 'assigned_users',
});
User.belongsToMany(Task, {
  through: taskassignment,  // Consistent reference
  foreignKey: 'collaborator_id',
  otherKey: 'task_id',
  as: 'assigned_tasks',
});

// Define associations for `Project` and `ProjectCollaborators`
Project.hasMany(ProjectCollaborators, { foreignKey: 'project_id', as: 'collaborators' });
ProjectCollaborators.belongsTo(Project, { foreignKey: 'project_id' });
ProjectCollaborators.belongsTo(User, { foreignKey: 'user_id', as: 'user' });
User.hasMany(ProjectCollaborators, { foreignKey: 'user_id', as: 'projectCollaborations' });

db.sequelize = sequelize;
db.Sequelize = Sequelize;

module.exports = db;