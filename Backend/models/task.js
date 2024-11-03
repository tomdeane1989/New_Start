// models/task.js
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class Task extends Model {}

  Task.init({
    task_id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    project_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'projects',
        key: 'project_id',
      },
    },
    stage_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'stages',
        key: 'stage_id',
      },
    },
    task_name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    due_date: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    priority: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    is_completed: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
    owner_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'users',
        key: 'user_id',
      },
    },
    created_at: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
    updated_at: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
  }, {
    sequelize,
    modelName: 'Task',
    tableName: 'tasks',
    timestamps: false,
  });

  return Task;
};