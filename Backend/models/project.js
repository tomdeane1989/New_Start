const { Model, DataTypes } = require('sequelize');
const sequelize = require('../config/database');

// models/project.js

module.exports = (sequelize, DataTypes) => {
    const { Model } = require('sequelize');  // Import Model directly from Sequelize
  
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
      description: DataTypes.TEXT,
      start_date: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
      end_date: DataTypes.DATE,
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
      tableName: 'projects',
      timestamps: false
    });
  
    // Define associations within the associate function
    Project.associate = (models) => {
      Project.belongsTo(models.User, { foreignKey: 'owner_id', as: 'owner' });
      Project.hasMany(models.ProjectCollaborators, { foreignKey: 'project_id', as: 'collaborators' });
    };
  
    return Project;
  };