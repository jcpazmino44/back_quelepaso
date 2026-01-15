const express = require('express');
const { create } = require('../controllers/survey.controller');

const router = express.Router();

router.post('/', create);

module.exports = router;
