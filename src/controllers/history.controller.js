const historyService = require('../services/history.service');

const list = async (req, res, next) => {
  try {
    const { userId } = req.query;
    const history = await historyService.listHistory(userId);
    res.json(
      history.map((item) => ({
        id: item.id,
        title: item.title,
        categoryId: item.category_id,
        category: item.category_slug,
        categoryInfo: item.category_slug
          ? {
            id: item.category_id,
            slug: item.category_slug,
            name: item.category_name,
            icon: item.category_icon,
            tintColor: item.category_tint_color,
            bgColor: item.category_bg_color
          }
          : null,
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
