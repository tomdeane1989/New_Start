// models/task.js
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Task extends Model {
    static associate(models) {
      this.belongsTo(models.Stage, {
        foreignKey: 'stage_id',
        as: 'stage',
        //onDelete: 'CASCADE', // If a stage is removed, tasks should be removed as well
        hooks: true,
      });
      this.belongsTo(models.Project, {
        foreignKey: 'project_id',
        as: 'project',
        //onDelete: 'CASCADE', // If a project is removed, tasks should be removed
        hooks: true,
      });
      this.belongsTo(models.User, {
        foreignKey: 'owner_id',
        as: 'owner',
        onDelete: 'SET NULL', // If the user is deleted, owner_id is set to NULL
      });
      this.belongsToMany(models.User, {
        through: models.TaskAssignment,
        as: 'assigned_users',
        foreignKey: 'task_id',
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
      // Make sure stage_id is defined and allowNull is true to avoid constraint errors
      stage_id: {
        type: DataTypes.INTEGER,
        allowNull: true, // Allow NULL to prevent constraint issues on deletion
      },
      project_id: {
        type: DataTypes.INTEGER,
        allowNull: false, // Assuming a task must always have a project
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