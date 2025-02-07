// models/taskAssignment.js

module.exports = (sequelize, DataTypes) => {
    const TaskAssignment = sequelize.define('TaskAssignment', {
        assignment_id: {
          type: DataTypes.INTEGER,
          primaryKey: true,
          autoIncrement: true,
        },
        task_id: {
          type: DataTypes.INTEGER,
          allowNull: false,
        },
        user_id: {
          type: DataTypes.INTEGER,
          allowNull: false,
        },
        can_edit: {
          type: DataTypes.BOOLEAN,
          defaultValue: false,
        },
        can_view: {
          type: DataTypes.BOOLEAN,
          defaultValue: true,
        },
        // NEW COLUMN:
        awaiting_approval: {
          type: DataTypes.BOOLEAN,
          defaultValue: false,
        },
      },
      {
        tableName: 'taskassignments',
        timestamps: false,
        modelName: 'TaskAssignment',
      }
    );
  
    TaskAssignment.associate = (models) => {
      TaskAssignment.belongsTo(models.Task, { foreignKey: 'task_id', as: 'task' });
      TaskAssignment.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
    };
  
    return TaskAssignment;
  };