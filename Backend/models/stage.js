const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Stage extends Model {
    static associate(models) {
      this.belongsTo(models.Project, { foreignKey: 'project_id', as: 'project' });
      this.hasMany(models.Task, { foreignKey: 'stage_id', as: 'tasks' });
    }
  }

  Stage.init(
    {
      stage_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      stage_name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      stage_order: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      is_custom: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      project_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
    },
    {
      sequelize,
      modelName: 'Stage',
      tableName: 'stages',
      timestamps: true,
      createdAt: 'created_at',
      updatedAt: 'updated_at',
    }
  );

  return Stage;
};