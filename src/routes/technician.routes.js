const express = require('express');
const { listByCity } = require('../controllers/technician.controller');

const router = express.Router();

router.get('/', listByCity);

module.exports = router;
