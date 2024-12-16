'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Add the column with a default value for existing rows
    await queryInterface.addColumn('companies', 'owner_id', {
      type: Sequelize.INTEGER,
      allowNull: false,
      defaultValue: 1, // Replace 1 with a valid user_id in your database
      references: {
        model: 'users',
        key: 'user_id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    });

    // Optionally, remove the default value after the migration
    await queryInterface.changeColumn('companies', 'owner_id', {
      type: Sequelize.INTEGER,
      allowNull: false,
      references: {
        model: 'users',
        key: 'user_id',
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.removeColumn('companies', 'owner_id');
  },
};