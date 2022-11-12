const mongoose = require("mongoose");
const { Schema } = mongoose;
const jwt = require("jsonwebtoken");

const userSchema = new Schema(
	{
		fullName: {
			type: String,
			required: true,
		},

		email: {
			type: String,
			required: true,
			unique: true,
		},

		mobileNumber: {
			type: String,
			required: false,
		},

		passwordHash: {
			type: String,
			required: true,
		},

		createdBy: {
			type: Schema.Types.ObjectId,
			required: false,
			default: null,
		},

		updatedBy: {
			type: Schema.Types.ObjectId,
			required: false,
			default: null,
		},

		isActive: {
			type: Boolean,
			required: false,
			default: false,
		},

		role: {
			type: String,
			enum: ["FARMER", "OFFICER", "CHEF"],
			default: "FARMER",
		},
	},
	{ timestamps: true }
);

userSchema.methods.genarateJwtToken = async function () {
	const user = this;
	const jwtSecret = process.env.jwtPrivateKey;

	const token = jwt.sign({ _id: user._id }, jwtSecret);
	user.token = token;
	return token;
};

module.exports = User = mongoose.model("User", userSchema);
