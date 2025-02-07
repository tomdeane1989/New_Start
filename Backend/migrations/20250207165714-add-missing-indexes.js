'use strict';
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.addIndex('tasks', ['owner_id'], {
      name: 'idx_tasks_owner_id'
    });
    await queryInterface.addIndex('documents', ['owner_id'], {
      name: 'idx_documents_owner_id'
    });
  },
  async down (queryInterface, Sequelize) {
    await queryInterface.removeIndex('tasks', 'idx_tasks_owner_id');
    await queryInterface.removeIndex('documents', 'idx_documents_owner_id');
  }
};