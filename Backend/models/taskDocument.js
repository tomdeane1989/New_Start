// Backend/models/taskDocument.js

const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class TaskDocument extends Model {
    static associate(models) {
      // This is the join table between Task and Document
    }
  }

  TaskDocument.init(
    {
      id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      task_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      document_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
    },
    {
      sequelize,
      modelName: 'TaskDocument',
      tableName: 'taskdocuments',
      timestamps: false,
    }
  );

  return TaskDocument;
};