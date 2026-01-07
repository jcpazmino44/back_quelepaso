const express = require('express');
const { list } = require('../controllers/tool.controller');

const router = express.Router();

router.get('/', list);

module.exports = router;
