const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const env = require('../config/env');
const userModel = require('../models/user.model');

const register = async ({ full_name, phone, password }) => {
  if (!phone || !password) {
    const error = new Error('phone and password are required');
    error.status = 400;
    throw error;
  }

  const existing = await userModel.findByPhone(phone);
  if (existing) {
    const error = new Error('phone already in use');
    error.status = 409;
    throw error;
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const userId = await userModel.create({ full_name, phone, password_hash: passwordHash });
  const user = await userModel.findById(userId);
  return sanitizeUser(user);
};

const login = async ({ phone, password }) => {
  if (!phone || !password) {
    const error = new Error('phone and password are required');
    error.status = 400;
    throw error;
  }

  const user = await userModel.findByPhone(phone);
  if (!user || !user.password_hash) {
    const error = new Error('invalid credentials');
    error.status = 401;
    throw error;
  }

  const matches = await bcrypt.compare(password, user.password_hash);
  if (!matches) {
    const error = new Error('invalid credentials');
    error.status = 401;
    throw error;
  }

  const token = jwt.sign({ sub: user.id }, env.jwt.secret, { expiresIn: env.jwt.expiresIn });
  return { token, user: sanitizeUser(user) };
};

const sanitizeUser = (user) => {
  if (!user) return null;
  const { password_hash, ...safeUser } = user;
  return safeUser;
};

module.exports = {
  register,
  login
};
