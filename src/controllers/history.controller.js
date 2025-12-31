const historyService = require('../services/history.service');

const list = async (req, res, next) => {
  try {
    const { userId } = req.query;
    const history = await historyService.listHistory(userId);
    res.json(
      history.map((item) => ({
        id: item.id,
        title: item.title,
        category: item.category,
        status: item.status,
        createdAt: item.created_at
      }))
    );
  } catch (error) {
    next(error);
  }
};

module.exports = {
  list
};
