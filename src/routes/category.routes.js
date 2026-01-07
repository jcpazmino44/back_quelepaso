const express = require('express');
const { list, listWithGuides } = require('../controllers/category.controller');

const router = express.Router();

router.get('/with-guides', listWithGuides);
router.get('/', list);

module.exports = router;
