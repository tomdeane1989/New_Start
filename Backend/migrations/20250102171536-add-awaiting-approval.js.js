'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    // 1) Add 'awaiting_approval' to 'projectcollaborators' table
    await queryInterface.addColumn('projectcollaborators', 'awaiting_approval', {
      type: Sequelize.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    });

    // 2) Add 'awaiting_approval' to 'taskassignments' table
    await queryInterface.addColumn('taskassignments', 'awaiting_approval', {
      type: Sequelize.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    });
  },

  async down(queryInterface, Sequelize) {
    // Revert
    await queryInterface.removeColumn('projectcollaborators', 'awaiting_approval');
    await queryInterface.removeColumn('taskassignments', 'awaiting_approval');
  },
};