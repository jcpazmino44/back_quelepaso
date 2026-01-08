const technicianService = require('../services/technician.service');

const listByCity = async (req, res, next) => {
  try {
    const { city, categorySlug } = req.query;
    const technicians = await technicianService.listByCity(city, categorySlug);
    res.json(technicians);
  } catch (error) {
    next(error);
  }
};

const listCities = async (req, res, next) => {
  try {
    const cities = await technicianService.listCities();
    res.json(cities);
  } catch (error) {
    next(error);
  }
};

module.exports = {
  listByCity,
  listCities
};
