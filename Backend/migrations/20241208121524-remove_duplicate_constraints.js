'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Based on the schema you provided, we have many duplicate constraints:
    // 1) companies_company_email_key duplicates: from companies_company_email_key1 to companies_company_email_key96
    // 2) companies_company_name_key duplicates: from companies_company_name_key1 to companies_company_name_key95
    // 3) users_email_key duplicates: from users_email_key1 to users_email_key92
    // 4) users_username_key duplicates: from users_username_key1 to users_username_key140

    // We'll remove all duplicates, leaving the original constraint intact (which is the one without any number).

    // Remove duplicate constraints for companies.company_email
    for (let i = 1; i <= 96; i++) {
      const constraintName = `companies_company_email_key${i}`;
      // Make sure constraint actually exists if running multiple times:
      // But typically no need, as this is a one-time migration.
      await queryInterface.removeConstraint('companies', constraintName)
        .catch(() => console.log(`Constraint ${constraintName} not found, skipping.`));
    }

    // Remove duplicate constraints for companies.company_name
    for (let i = 1; i <= 95; i++) {
      const constraintName = `companies_company_name_key${i}`;
      await queryInterface.removeConstraint('companies', constraintName)
        .catch(() => console.log(`Constraint ${constraintName} not found, skipping.`));
    }

    // Remove duplicate constraints for users.email
    for (let i = 1; i <= 92; i++) {
      const constraintName = `users_email_key${i}`;
      await queryInterface.removeConstraint('users', constraintName)
        .catch(() => console.log(`Constraint ${constraintName} not found, skipping.`));
    }

    // Remove duplicate constraints for users.username
    for (let i = 1; i <= 140; i++) {
      const constraintName = `users_username_key${i}`;
      await queryInterface.removeConstraint('users', constraintName)
        .catch(() => console.log(`Constraint ${constraintName} not found, skipping.`));
    }

    // The original constraints (e.g., companies_company_email_key, companies_company_name_key, users_email_key, users_username_key)
    // remain intact, so we do not remove them. We only remove those with appended numbers.
  },

  down: async (queryInterface, Sequelize) => {
    // In a down migration, you would re-add these constraints if needed.
    // But since they were duplicates, we generally don't want to restore them.
    // This can safely be left empty.

    // Example of how you'd re-add one (if you ever wanted to):
    // await queryInterface.addConstraint('companies', {
    //   fields: ['company_email'],
    //   type: 'unique',
    //   name: 'companies_company_email_key2'
    // });
  }
};