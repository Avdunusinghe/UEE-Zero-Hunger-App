const mongoose = require("mongoose");
const { Schema } = mongoose;

const questionSchema = new Schema(
	{
		question: {
			type: String,
			required: true,
		},

		answerText: {
			type: String,
			default: null,
			required: false,
		},

		submittedBy: {
			type: Schema.Types.ObjectId,
			required: true,
			default: null,
			ref: "User",
		},

		answeredBy: {
			type: Schema.Types.ObjectId,
			required: false,
			default: null,
			ref: "User",
		},

		isAnswered: {
			type: Boolean,
			required: false,
			default: false,
		},

		isActive: {
			type: Boolean,
			required: false,
			default: false,
		},
	},
	{ timestamps: true }
);

module.exports = User = mongoose.model("Question", questionSchema);
