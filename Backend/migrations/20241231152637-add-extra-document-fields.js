'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('documents', 'original_filename', {
      type: Sequelize.STRING,
      allowNull: true,
    });
    await queryInterface.addColumn('documents', 'uploaded_by', {
      type: Sequelize.STRING,
      allowNull: true,
    });
    await queryInterface.addColumn('documents', 'uploaded_date', {
      type: Sequelize.DATE,
      defaultValue: Sequelize.fn('NOW'),
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('documents', 'original_filename');
    await queryInterface.removeColumn('documents', 'uploaded_by');
    await queryInterface.removeColumn('documents', 'uploaded_date');
  }
};