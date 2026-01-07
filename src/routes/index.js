const express = require('express');

const authRoutes = require('./auth.routes');
const categoryRoutes = require('./category.routes');
const deviceRoutes = require('./device.routes');
const diagnosticRoutes = require('./diagnostic.routes');
const eventRoutes = require('./event.routes');
const guideRoutes = require('./guide.routes');
const healthRoutes = require('./health.routes');
const historyRoutes = require('./history.routes');
const metricsRoutes = require('./metrics.routes');
const technicianRoutes = require('./technician.routes');
const toolRoutes = require('./tool.routes');

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/categories', categoryRoutes);
router.use('/devices', deviceRoutes);
router.use('/diagnostics', diagnosticRoutes);
router.use('/events', eventRoutes);
router.use('/guides', guideRoutes);
router.use('/health', healthRoutes);
router.use('/history', historyRoutes);
router.use('/metrics', metricsRoutes);
router.use('/technicians', technicianRoutes);
router.use('/tools', toolRoutes);

module.exports = router;
