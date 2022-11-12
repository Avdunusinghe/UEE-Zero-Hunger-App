const User = require("../models/user.model");
const bcrypt = require("bcrypt");
const _logger = require("../utils/logger");
const _currentUserService = require("../middleware/http.context.accessor");
/**
 * User Service Service
 * @param {UserViewModel}
 * @service save and Update Service
 * @returns {Promise<ResultViewModel>}
 */

const saveUser = async (request, response) => {
	try {
		let { id, fullName, email, mobileNumber, password, role } = request.body;

		if (id == null) {
			let user = new User({
				fullName,
				email,
				mobileNumber,
				passwordHash: password,
				isActive: true,
				role,
			});

			const salt = await bcrypt.genSalt(10);
			user.passwordHash = await bcrypt.hash(user.passwordHash, salt);
			await user.save();

			response.json({ isSuccess: true, message: "Registration Successfully" });
		} else {
			const isUserAvailable = await User.findById(id);

			if (!isUserAvailable) {
				response.json({
					isSuccess: false,
					message: "Cannot Find User",
				});
			}

			const userObj = await User.findByIdAndUpdate(id, {
				fullName,
				email,
				mobileNumber,
				password,
				role,
			});

			response.json({
				isSuccess: true,
				message: "User has been  Update SuccessFully",
			});
		}
	} catch (error) {
		_logger.error(error);
		response.json({
			isSuccess: false,
			message: "Error has been occured please try again",
		});
	}
};

module.exports = {
	saveUser,
};
