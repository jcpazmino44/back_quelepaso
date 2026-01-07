const express = require('express');
const {
  getBySlug,
  list,
  listByCategory
} = require('../controllers/guide.controller');

const router = express.Router();

router.get('/by-category/:slug', listByCategory);
router.get('/', list);
router.get('/:slug', getBySlug);

module.exports = router;
