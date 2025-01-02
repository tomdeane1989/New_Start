const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Company extends Model {
    static associate(models) {
      this.hasMany(models.User, { foreignKey: 'company_id', as: 'users' });
    }
  }

  Company.init(
    {
      company_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      company_name: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
      },
      company_email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
      },
      owner_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: 'users', // Ensure the table name matches your `User` model
          key: 'user_id',
        },
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE',
      },
    },
    {
      sequelize,
      modelName: 'Company',
      tableName: 'companies',
      timestamps: true,
      createdAt: 'created_at',
      updatedAt: 'updated_at',
    }
  );

  return Company;
};