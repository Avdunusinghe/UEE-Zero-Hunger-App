const User = require("../models/user.model");
const bcrypt = require("bcrypt");
const _logger = require("../utils/logger");
/**
 * Auth  Service
 * @param {loginViewModel}
 * @service sAuth Service
 * @returns {Promise<AuthenticationViewModel>}
 */
const login = async (request, response) => {
	try {
		const { email, password } = request.body;
		let user = await User.findOne({ email: request.body.email });

		if (!user) {
			response.json({
				isLogged: false,
				message: "Invalid User Please Register",
			});
		} else {
			const isValidPassword = await bcrypt.compare(request.body.password, user.passwordHash);

			if (!isValidPassword) {
				response.json({
					isLogged: false,
					message: "Password Incorrect",
				});
			}

			const token = await user.genarateJwtToken();
			authenticationViewModel = {
				token: token,
				userId: user._id,
				email: user.email,
				dispalyName: user.firstName,
				role: user.role,
				isLogged: true,
			};
			response.header("Bearer", token).json(authenticationViewModel).send();
		}
	} catch (error) {
		_logger.error(error);
	}
};

module.exports = {
	login,
};
