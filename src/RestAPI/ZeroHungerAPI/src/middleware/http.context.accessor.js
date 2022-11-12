const _httpContextAccessor = require("jwt-decode");
const _logger = require("../utils/logger");

function identityService(request) {
	let context;
	let identitdy;
	if (request.headers.authorization && request.headers.authorization.split(" ")[0] === "Bearer") {
		context = request.headers.authorization.split(" ")[1];
		identitdy = _httpContextAccessor(context);

		return identitdy._id;
	} else if (request.query && request.query.token) {
		context = request.query.token;
		identitdy = _httpContextAccessor(context);

		return identitdy._id;
	}
}

module.exports = identityService;
