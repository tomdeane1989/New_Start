// models/stage.js

const { Model, DataTypes } = require('sequelize');
const sequelize = require('../config/database'); // Adjust this path if your database config is located elsewhere
const Project = require('./project'); // Import the Project model for association

class Stage extends Model {}

Stage.init({
    stage_id: {
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
    stage_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    stage_order: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    description: {
        type: DataTypes.STRING,
        allowNull: true
    },
    is_custom: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false
    },
    created_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
    },
    updated_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
    }
}, {
    sequelize,
    modelName: 'Stage',
    tableName: 'stages', // Ensures consistent table name
    timestamps: false
});

// Define associations
Stage.belongsTo(Project, { foreignKey: 'project_id', onDelete: 'CASCADE' });

module.exports = Stage;