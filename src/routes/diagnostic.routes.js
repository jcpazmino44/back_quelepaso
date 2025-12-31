const express = require('express');
const { create } = require('../controllers/diagnostic.controller');

const router = express.Router();

router.post('/', create);

module.exports = router;
