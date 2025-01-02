// models/projectCollaborators.js
// Backend/models/projectCollaborators.js

const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class ProjectCollaborator extends Model {
    static associate(models) {
      console.log('Associating ProjectCollaborator with Project and User');
      this.belongsTo(models.Project, { foreignKey: 'project_id', as: 'project' });
      this.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
      console.log('Associations for ProjectCollaborator:', this.associations);
    }
  }

  ProjectCollaborator.init(
    {
      collaborator_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
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
        type: DataTypes.INTEGER, // Store role as an integer
        allowNull: false,
        defaultValue: 0 // Default to Buyer (0)
      },
      assigned_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
    },
    {
      sequelize,
      modelName: 'ProjectCollaborator',
      tableName: 'projectcollaborators',
      timestamps: true,
      createdAt: 'created_at',
      updatedAt: 'updated_at',
    }
  );

  return ProjectCollaborator;
};