module.exports = {
  up: async (queryInterface, Sequelize) => {
      await queryInterface.changeColumn('projectcollaborators', 'role', {
          type: Sequelize.ENUM(
              'Buyer',
              'Seller',
              'Mortgage Advisor',
              'Seller Solicitor',
              'Buyer Solicitor',
              'Estate Agent'
          ),
          allowNull: false
      });
  },
  down: async (queryInterface, Sequelize) => {
      await queryInterface.changeColumn('projectcollaborators', 'role', {
          type: Sequelize.STRING,
          allowNull: false
      });
  }
};