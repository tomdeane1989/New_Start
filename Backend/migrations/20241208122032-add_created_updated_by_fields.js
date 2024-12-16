'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Add to 'projects'
    await queryInterface.addColumn('projects', 'created_by', {
      type: Sequelize.INTEGER,
      references: { model: 'users', key: 'user_id' },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
      allowNull: true
    });
    await queryInterface.addColumn('projects', 'updated_by', {
      type: Sequelize.INTEGER,
      references: { model: 'users', key: 'user_id' },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
      allowNull: true
    });

    // Add to 'stages'
    await queryInterface.addColumn('stages', 'created_by', {
      type: Sequelize.INTEGER,
      references: { model: 'users', key: 'user_id' },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
      allowNull: true
    });
    await queryInterface.addColumn('stages', 'updated_by', {
      type: Sequelize.INTEGER,
      references: { model: 'users', key: 'user_id' },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
      allowNull: true
    });

    // Add to 'tasks'
    await queryInterface.addColumn('tasks', 'created_by', {
      type: Sequelize.INTEGER,
      references: { model: 'users', key: 'user_id' },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
      allowNull: true
    });
    await queryInterface.addColumn('tasks', 'updated_by', {
      type: Sequelize.INTEGER,
      references: { model: 'users', key: 'user_id' },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
      allowNull: true
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.removeColumn('projects', 'created_by');
    await queryInterface.removeColumn('projects', 'updated_by');
    await queryInterface.removeColumn('stages', 'created_by');
    await queryInterface.removeColumn('stages', 'updated_by');
    await queryInterface.removeColumn('tasks', 'created_by');
    await queryInterface.removeColumn('tasks', 'updated_by');
  }
};