const dotenv = require("dotenv");
dotenv.config();

const configurationManager = {
  connectionString: process.env.connectionString,
};

module.exports = configurationManager;
