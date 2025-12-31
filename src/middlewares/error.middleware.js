const notFoundHandler = (req, res, next) => {
  res.status(404).json({ message: 'not found' });
};

const errorHandler = (err, req, res, next) => {
  const status = err.status || 500;
  res.status(status).json({ message: err.message || 'internal error' });
};

module.exports = {
  notFoundHandler,
  errorHandler
};
