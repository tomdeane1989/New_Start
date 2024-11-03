const { Model, DataTypes } = require('sequelize');
const sequelize = require('../config/database');

// models/projectCollaborators.js

module.exports = (sequelize, DataTypes) => {
    const { Model } = require('sequelize');  // Import Model directly from Sequelize
  
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
      },
      user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
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
      tableName: 'projectcollaborators',
      timestamps: false
    });
  
    // Define associations
    ProjectCollaborators.associate = (models) => {
      ProjectCollaborators.belongsTo(models.Project, { foreignKey: 'project_id', as: 'project' });
      ProjectCollaborators.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
    };
  
    return ProjectCollaborators;
  };