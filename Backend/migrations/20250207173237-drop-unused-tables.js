module.exports = {
  async up(queryInterface, Sequelize) {
    // If you want to drop them:
    await queryInterface.dropTable('collaborator_audit');
    await queryInterface.dropTable('project_status_history');
    await queryInterface.dropTable('role_attributes');
    await queryInterface.dropTable('roles');
  },
  async down(queryInterface, Sequelize) {
    // If you want a down method, you'd recreate them 
    // with the same structure, but you probably won't need that 
    // unless you might roll back.
  }
};