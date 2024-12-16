// models/taskassignment.js
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
    }, {
        tableName: 'taskassignments',
        timestamps: false,
        modelName: 'TaskAssignment', // Ensure modelName is set so references to models.TaskAssignment work correctly
    });

    // Define associations
    TaskAssignment.associate = (models) => {
        TaskAssignment.belongsTo(models.Task, { foreignKey: 'task_id', as: 'task' });
        TaskAssignment.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
    };

    console.log("TaskAssignment model initialized.");
    return TaskAssignment;
};