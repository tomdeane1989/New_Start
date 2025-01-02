// Backend/models/user.js

const { Model, DataTypes } = require('sequelize');
const bcrypt = require('bcrypt');

module.exports = (sequelize) => {
  class User extends Model {
    static associate(models) {
      this.belongsTo(models.Company, { foreignKey: 'company_id', as: 'company' });
      this.hasMany(models.Project, { foreignKey: 'owner_id', as: 'ownedProjects' });
      this.hasMany(models.ProjectCollaborator, { foreignKey: 'user_id', as: 'projectCollaborations' });
      this.belongsToMany(models.Task, { through: models.TaskAssignment, foreignKey: 'user_id', as: 'tasks' });
    }

    // Instance method to validate password
    async validatePassword(password) {
      return await bcrypt.compare(password, this.password_hash);
    }
  }

  User.init(
    {
      user_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      company_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
          model: 'companies',
          key: 'company_id',
        },
        onDelete: 'SET NULL',
        onUpdate: 'CASCADE',
      },
      username: {
        type: DataTypes.STRING(255),
        allowNull: false,
        unique: true,
      },
      email: {
        type: DataTypes.STRING(255),
        allowNull: false,
        unique: true,
        validate: { isEmail: true },
      },
      password_hash: {
        type: DataTypes.STRING(255),
        allowNull: false,
      },
      first_name: {
        type: DataTypes.STRING(255),
        allowNull: true,
      },
      last_name: {
        type: DataTypes.STRING(255),
        allowNull: true,
      },
      is_active: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: true,
      },
      created_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
      updated_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
    },
    {
      sequelize,
      modelName: 'User',
      tableName: 'users',
      timestamps: true,
      createdAt: 'created_at',
      updatedAt: 'updated_at',
      hooks: {
        beforeCreate: async (user) => {
          if (user.password_hash && !user.password_hash.startsWith('$2b$')) {
            const salt = await bcrypt.genSalt(10);
            user.password_hash = await bcrypt.hash(user.password_hash, salt);
          }
        },
        beforeUpdate: async (user) => {
          if (user.changed('password_hash') && !user.password_hash.startsWith('$2b$')) {
            const salt = await bcrypt.genSalt(10);
            user.password_hash = await bcrypt.hash(user.password_hash, salt);
          }
        },
      }
    }
  );

  return User;
};