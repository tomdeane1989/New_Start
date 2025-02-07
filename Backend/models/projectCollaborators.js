// models/projectCollaborators.js

const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class ProjectCollaborator extends Model {
    static associate(models) {
      this.belongsTo(models.Project, { foreignKey: 'project_id', as: 'project' });
      this.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
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
        type: DataTypes.INTEGER, 
        allowNull: false,
        defaultValue: 0
      },
      assigned_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
      // NEW COLUMN:
      awaiting_approval: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
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