'use strict';
module.exports = {
    up: async (queryInterface, Sequelize) => {
        await queryInterface.addColumn('projects', 'owner_id', {
            type: Sequelize.INTEGER,
            allowNull: false,
            defaultValue: 3,  // Replace 1 with the appropriate user ID
            references: {
                model: 'users',
                key: 'user_id'
            },
            onUpdate: 'CASCADE',
            onDelete: 'SET NULL'
        });
    },

    down: async (queryInterface, Sequelize) => {
        await queryInterface.removeColumn('projects', 'owner_id');
    }
};