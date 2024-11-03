'use strict';
module.exports = {
    up: async (queryInterface, Sequelize) => {
        await queryInterface.dropTable('TaskAssignments');
    },
    down: async (queryInterface, Sequelize) => {
        // Re-create the TaskAssignments table if needed on rollback
        await queryInterface.createTable('TaskAssignments', {
            task_id: {
                type: Sequelize.INTEGER,
                primaryKey: true,
                references: { model: 'tasks', key: 'task_id' }
            },
            user_id: {
                type: Sequelize.INTEGER,
                primaryKey: true,
                references: { model: 'users', key: 'user_id' }
            },
            created_at: Sequelize.DATE,
            updated_at: Sequelize.DATE
        });
    }
};