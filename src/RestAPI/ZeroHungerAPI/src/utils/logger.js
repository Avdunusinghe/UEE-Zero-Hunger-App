const pino = require("pino");

const logger = pino({
	transport: {
		target: "pino-pretty",
		options: {
			colorize: true,
			translateTime: "SYS:yyyy-mm-dd HH:MM:ss",
			ignore: "pid,hostname",
		},
	},
});

module.exports = logger;
