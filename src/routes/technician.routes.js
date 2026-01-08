const express = require('express');
const { listByCity, listCities } = require('../controllers/technician.controller');

const router = express.Router();

router.get('/cities', listCities);
router.get('/', listByCity);

module.exports = router;
