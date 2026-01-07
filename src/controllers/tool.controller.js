const toolService = require('../services/tool.service');

const list = async (req, res, next) => {
  try {
    const items = await toolService.listTools();
    res.json({
      items: items.map((tool) => ({
        id: tool.id,
        slug: tool.slug,
        name: tool.name,
        icon: tool.icon
      }))
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  list
};
