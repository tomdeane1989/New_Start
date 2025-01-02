// models/task.js
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Task extends Model {
    static associate(models) {
      this.belongsTo(models.Stage, {
        foreignKey: 'stage_id',
        as: 'stage',
        hooks: true,
      });
      this.belongsTo(models.Project, {
        foreignKey: 'project_id',
        as: 'project',
        hooks: true,
      });
      this.belongsTo(models.User, {
        foreignKey: 'owner_id',
        as: 'owner',
        onDelete: 'SET NULL',
      });
      this.belongsToMany(models.User, {
        through: models.TaskAssignment,
        as: 'assigned_users',
        foreignKey: 'task_id',
      });

      // **New Association**
      this.hasMany(models.TaskAssignment, {
        foreignKey: 'task_id',
        as: 'taskAssignments', // This alias should match the one used in controller
        onDelete: 'CASCADE', // Optional: Define behavior on task deletion
        hooks: true,
      });
      this.belongsToMany(models.Document, {
        through: models.TaskDocument,
        foreignKey: 'task_id',
        otherKey: 'document_id',
        as: 'documents',
      });
    }
  }

  Task.init(
    {
      task_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      stage_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      project_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      task_name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      is_completed: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      owner_id: {
        type: DataTypes.INTEGER,
        allowNull: true, 
      },
      description: DataTypes.STRING,
      due_date: DataTypes.DATE,
      priority: DataTypes.STRING,
    },
    {
      sequelize,
      modelName: 'Task',
      tableName: 'tasks',
      timestamps: true,
      createdAt: 'created_at',
      updatedAt: 'updated_at',
    }
  );

  return Task;
};