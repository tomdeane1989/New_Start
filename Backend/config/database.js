const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('project_db', 'thomasdeane', 'test', {
  host: 'localhost',
  dialect: 'postgres',
  logging: false, // Set to true to see SQL queries in the console
});

async function testConnection() {
  try {
    await sequelize.authenticate();
    console.log('Database connection established successfully.');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
}

testConnection();

module.exports = sequelize;