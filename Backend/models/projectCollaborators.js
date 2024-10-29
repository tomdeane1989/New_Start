// models/projectCollaborators.js

const { Model, DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const Project = require('./project');
const User = require('./user');

class ProjectCollaborators extends Model {}

ProjectCollaborators.init({
    collaborator_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    project_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: Project,
            key: 'project_id'
        },
        onDelete: 'CASCADE'
    },
    user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: User,
            key: 'user_id'
        },
        onDelete: 'CASCADE'
    },
    role: {
        type: DataTypes.ENUM(
            'Buyer',
            'Seller',
            'Mortgage Advisor',
            'Seller Solicitor',
            'Buyer Solicitor',
            'Estate Agent'
        ),
        allowNull: false
    },
    assigned_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
    }
}, {
    sequelize,
    modelName: 'ProjectCollaborators',
    tableName: 'projectcollaborators',  // Specifying exact table name to prevent case issues
    timestamps: false
});

// Define associations
ProjectCollaborators.belongsTo(Project, { foreignKey: 'project_id' });
ProjectCollaborators.belongsTo(User, { foreignKey: 'user_id' });

module.exports = ProjectCollaborators;