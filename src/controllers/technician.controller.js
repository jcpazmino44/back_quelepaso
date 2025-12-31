const technicianService = require('../services/technician.service');

const listByCity = async (req, res, next) => {
  try {
    const { city } = req.query;
    const technicians = await technicianService.listByCity(city);
    res.json(technicians);
  } catch (error) {
    next(error);
  }
};

module.exports = {
  listByCity
};
