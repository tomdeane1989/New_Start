// Backend/models/project.js

const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Project extends Model {
    static associate(models) {
      this.hasMany(models.ProjectCollaborator, {
        foreignKey: 'project_id',
        as: 'collaborators',
        onDelete: 'CASCADE',
        hooks: true,
      });
      this.hasMany(models.Stage, {
        foreignKey: 'project_id',
        as: 'stages',
        onDelete: 'CASCADE',
        hooks: true,
      });
      this.hasMany(models.Task, {
        foreignKey: 'project_id',
        as: 'tasks',
        onDelete: 'CASCADE',
        hooks: true,
      });
      this.belongsTo(models.User, {
        foreignKey: 'owner_id',
        as: 'owner',
      });
    }
  }

  Project.init(
    {
      project_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      project_name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      owner_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: 'users',
          key: 'user_id',
        },
      },
      description: DataTypes.TEXT,
      status: {
        type: DataTypes.ENUM('active', 'completed', 'archived'),
        defaultValue: 'active',
      },
    },
    {
      sequelize,
      modelName: 'Project',
      tableName: 'projects',
      timestamps: true,
      createdAt: 'created_at',
      updatedAt: 'updated_at',
    }
  );

  return Project;
};