const toolModel = require('../models/tool.model');

const listTools = async () => {
  return toolModel.listAll();
};

module.exports = {
  listTools
};
