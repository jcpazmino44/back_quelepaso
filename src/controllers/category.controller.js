const categoryService = require('../services/category.service');

const list = async (req, res, next) => {
  try {
    const { isQuick } = req.query;
    const isQuickFlag =
      isQuick === 'true' ||
      isQuick === '1' ||
      isQuick === true;

    const categories = await categoryService.listCategories({
      isQuick: isQuick !== undefined ? isQuickFlag : undefined
    });

    res.json(
      categories.map((item) => ({
        id: item.id,
        slug: item.slug,
        name: item.name,
        description: item.description,
        icon: item.icon,
        imageUrl: item.image_url,
        tintColor: item.tint_color,
        bgColor: item.bg_color,
        isQuick: item.is_quick,
        orderIndex: item.order_index,
        isActive: item.is_active
      }))
    );
  } catch (error) {
    next(error);
  }
};

module.exports = {
  list
};
