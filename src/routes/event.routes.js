const express = require('express');
const { create } = require('../controllers/event.controller');

const router = express.Router();

router.post('/', create);

module.exports = router;
