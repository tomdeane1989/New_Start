// models/taskassignment.js

module.exports = (sequelize, DataTypes) => {
    const taskassignment = sequelize.define('taskassignment', {  // Model name matches file name (singular, lowercase)
        assignment_id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true,
        },
        task_id: {
            type: DataTypes.INTEGER,
            allowNull: false,
            references: {
                model: 'tasks',
                key: 'task_id',
            },
        },
        collaborator_id: {
            type: DataTypes.INTEGER,
            allowNull: false,
            references: {
                model: 'users',
                key: 'user_id',
            },
        },
        can_view: {
            type: DataTypes.BOOLEAN,
            defaultValue: true,
        },
        can_edit: {
            type: DataTypes.BOOLEAN,
            defaultValue: false,
        }
    }, {
        tableName: 'taskassignments', // Matches database table name (plural)
        timestamps: false,
    });

    return taskassignment;
};