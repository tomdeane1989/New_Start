const { Model, DataTypes } = require('sequelize');
const bcrypt = require('bcrypt');
const sequelize = require('../config/database');
//const { User } = require('../models'); // re engage this if anything breaks - also revert config file to incorrect .js model

module.exports = (sequelize, DataTypes) => {
    class User extends Model {
      static async hashPassword(password) {
        return await bcrypt.hash(password, 10);
      }
  
      async validatePassword(password) {
        return await bcrypt.compare(password, this.password_hash);
      }
    }
  
    User.init({
      user_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      username: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
      },
      email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        validate: { isEmail: true },
      },
      password_hash: {
        type: DataTypes.TEXT,
        allowNull: false,
      },
      role: DataTypes.STRING,
      first_name: DataTypes.STRING,
      last_name: DataTypes.STRING,
      phone_number: DataTypes.STRING,
      address: DataTypes.TEXT,
      date_of_birth: DataTypes.DATE,
      created_at: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
      updated_at: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
      is_active: { type: DataTypes.BOOLEAN, defaultValue: true },
      bio: DataTypes.TEXT,
      profile_picture_url: DataTypes.TEXT,
      preferences: DataTypes.JSONB,
    }, {
      sequelize,
      modelName: 'User',
      tableName: 'users',
      timestamps: false,
    });
  
    User.associate = (models) => {
      User.hasMany(models.Project, { foreignKey: 'owner_id', as: 'projects' });
      User.hasMany(models.ProjectCollaborators, { foreignKey: 'user_id', as: 'collaborations' });
    };
  
    return User;
  };