// Backend/models/document.js

const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Document extends Model {
    static associate(models) {
      this.belongsToMany(models.Task, {
        through: models.TaskDocument,
        foreignKey: 'document_id',
        otherKey: 'task_id',
        as: 'tasks',
      });
      this.belongsTo(models.User, { foreignKey: 'owner_id', as: 'owner' });
    }
  }

  Document.init(
    {
      document_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      owner_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      file_name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      file_url: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      tags: {
        type: DataTypes.ARRAY(DataTypes.STRING),
        defaultValue: [],
      },
      original_filename: {
        type: DataTypes.STRING, // e.g. user’s original "myhouse.pdf"
        allowNull: true,
      },
      uploaded_by: {
        type: DataTypes.STRING, // or integer if you want user_id
        allowNull: true,
      },
      uploaded_date: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
    },
    {
      sequelize,
      modelName: 'Document',
      tableName: 'documents',
      timestamps: true,
      createdAt: 'created_at',
      updatedAt: 'updated_at',
    }
  );

  return Document;
};