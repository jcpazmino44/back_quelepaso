const express = require('express');
const { upsert } = require('../controllers/device.controller');

const router = express.Router();

router.post('/', upsert);

module.exports = router;
