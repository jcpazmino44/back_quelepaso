const express = require('express');

const authRoutes = require('./auth.routes');
const diagnosticRoutes = require('./diagnostic.routes');
const healthRoutes = require('./health.routes');
const historyRoutes = require('./history.routes');
const technicianRoutes = require('./technician.routes');

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/diagnostics', diagnosticRoutes);
router.use('/health', healthRoutes);
router.use('/history', historyRoutes);
router.use('/technicians', technicianRoutes);

module.exports = router;
