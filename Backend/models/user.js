// user.js
const { Model, DataTypes } = require('sequelize');
const bcrypt = require('bcrypt');
const sequelize = require('../config/database');

class User extends Model {
    // Method to hash password
    static async hashPassword(password) {
        return await bcrypt.hash(password, 10);
    }

    // Method to check password
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
        validate: {
            isEmail: true,
        },
    },
    password_hash: {
        type: DataTypes.TEXT,
        allowNull: false,
    },
    role: {
        type: DataTypes.STRING,
        allowNull: true,
    },
    first_name: DataTypes.STRING,
    last_name: DataTypes.STRING,
    phone_number: DataTypes.STRING,
    address: DataTypes.TEXT,
    date_of_birth: DataTypes.DATE,
    created_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
    },
    updated_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
    },
    is_active: {
        type: DataTypes.BOOLEAN,
        defaultValue: true,
    },
    bio: DataTypes.TEXT,
    profile_picture_url: DataTypes.TEXT,
    preferences: DataTypes.JSONB,
}, {
    sequelize,
    modelName: 'User',
    tableName: 'users', // Explicitly set table name
    timestamps: false,
});

module.exports = User;