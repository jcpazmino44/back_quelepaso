const express = require('express');
const { create } = require('../controllers/metrics.controller');
const apiKeyAuth = require('../middlewares/apiKey.middleware');

const router = express.Router();

router.post('/', apiKeyAuth, create);

module.exports = router;
