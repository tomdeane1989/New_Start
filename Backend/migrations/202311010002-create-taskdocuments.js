'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('taskdocuments', {
      id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      task_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      document_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('taskdocuments');
  },
};