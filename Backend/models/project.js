// models/project.js

const { Model, DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const User = require('./user'); // Assuming owner relationship with User

class Project extends Model {}

Project.init({
    project_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    project_name: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    description: {
        type: DataTypes.TEXT,
    },
    start_date: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
    },
    end_date: {
        type: DataTypes.DATE,
    },
    status: {
        type: DataTypes.STRING,
        defaultValue: 'active',
    },
    created_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
    },
    updated_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
    }
}, {
    sequelize,
    modelName: 'Project',
    tableName: 'projects', // Enforce lowercase table name
    timestamps: false
});

// Define association
Project.belongsTo(User, { foreignKey: 'owner_id', as: 'owner' });
User.hasMany(Project, { foreignKey: 'owner_id', as: 'projects' });

module.exports = Project;