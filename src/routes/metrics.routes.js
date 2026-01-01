const express = require('express');
const { create } = require('../controllers/metrics.controller');

const router = express.Router();

router.post('/', create);

module.exports = router;
