const express = require('express');
const { create, updateStatus } = require('../controllers/diagnostic.controller');

const router = express.Router();

router.post('/', create);
router.patch('/:id/status', updateStatus);

module.exports = router;
