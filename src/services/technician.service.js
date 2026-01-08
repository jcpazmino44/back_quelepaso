const technicianModel = require('../models/technician.model');

const listByCity = async (city) => {
  if (!city) {
    const error = new Error('city is required');
    error.status = 400;
    throw error;
  }

  const rows = await technicianModel.findActiveByCity(city);
  return rows.map((row) => ({
    id: row.id,
    name: row.name,
    role: row.role,
    zone: row.zone,
    phone: row.phone,
    rating: Number(row.rating),
    reviewsCount: row.reviews_count
  }));
};

const listCities = async () => {
  const rows = await technicianModel.listActiveCities();
  return rows
    .map((row) => row.city)
    .filter((city) => city);
};

module.exports = {
  listByCity,
  listCities
};
