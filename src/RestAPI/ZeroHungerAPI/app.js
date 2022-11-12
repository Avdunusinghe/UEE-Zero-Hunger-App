//Load modules
const dotenv = require("dotenv");
dotenv.config();
const configurationManager = require("./src/config/api.config");
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const logger = require("./src/utils/logger");
//Create the Express App
const app = express();

//Order Routes
const chefRoutes = require("./src/routes/chef.routes");

//Setup Request body JSON Parsing
app.use(express.json());

app.use(express.urlencoded({ extended: true }));
//order service
app.use(chefRoutes);

//Enable All CORS Requests
app.use(cors());
app.use(helmet());

mongoose.connect(configurationManager.connectionString, {
	useNewUrlParser: true,
	useUnifiedTopology: true,
});

//Configure Services
app.use("/api/auth", require("./src/routes/auth.routes"));
app.use("/api/user", require("./src/routes/user.routes"));
app.use("/api/question", require("./src/routes/question.routes"));

mongoose.connection.once("open", () => {
	logger.info(" Connect UEE Database....");
});
if (app.get("env") === "development") {
	app.use(morgan("tiny"));
	logger.info("Enabled Morgon......");
}

app.get("/", (request, response) => {
	response.send("<h3>🖥️ Welcome API Documentation</h3>");
});

const port = process.env.PORT || 4000;

app.listen(port, () => {
	logger.info(`Web API Development: ${port}`);
});
