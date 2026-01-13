const express = require('express');
const { create, updateStatus } = require('../controllers/diagnostic.controller');
const multer = require('multer');

const router = express.Router();
const upload = multer();

router.post('/', upload.none(), create);
router.patch('/:id/status', updateStatus);

module.exports = router;
