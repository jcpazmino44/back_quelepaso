const categoryModel = require('../models/category.model');

const listCategories = async ({ isQuick } = {}) => {
  return categoryModel.listActive({ isQuick });
};

const getCategoryById = async (categoryId) => {
  if (!categoryId) {
    return null;
  }
  return categoryModel.findById(categoryId);
};

const getCategoryBySlug = async (slug) => {
  if (!slug) {
    return null;
  }
  return categoryModel.findBySlug(slug);
};

module.exports = {
  listCategories,
  getCategoryById,
  getCategoryBySlug
};
