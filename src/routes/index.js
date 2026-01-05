const express = require('express');

const authRoutes = require('./auth.routes');
const deviceRoutes = require('./device.routes');
const diagnosticRoutes = require('./diagnostic.routes');
const eventRoutes = require('./event.routes');
const healthRoutes = require('./health.routes');
const historyRoutes = require('./history.routes');
const metricsRoutes = require('./metrics.routes');
const technicianRoutes = require('./technician.routes');

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/devices', deviceRoutes);
router.use('/diagnostics', diagnosticRoutes);
router.use('/events', eventRoutes);
router.use('/health', healthRoutes);
router.use('/history', historyRoutes);
router.use('/metrics', metricsRoutes);
router.use('/technicians', technicianRoutes);

module.exports = router;
