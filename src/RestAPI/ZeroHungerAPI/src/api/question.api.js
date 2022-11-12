const Question = require("../models/question.model");
const _logger = require("../utils/logger");
const _currentUserService = require("../middleware/http.context.accessor");

/**
 * Question Service
 * @param {questionViewModel}
 * @service submit Question Service
 * @returns {Promise<ResultViewModel>}
 *  */

const submitQuestion = async (request, response) => {
	try {
		let { id, question } = request.body;
		const loggedInUserId = _currentUserService(request, response);

		if (id === null) {
			let questionModel = new Question({
				question,
				answerText: "",
				submittedBy: loggedInUserId,
				isActive: true,
			});

			await questionModel.save();

			response.json({ isSuccess: true, message: "Question Submitted Successfully" });
		} else {
			const isQuestionAvailable = await Question.findById(id);

			if (!isQuestionAvailable) {
				response.json({
					isSuccess: false,
					message: "Cannot Find Question",
				});
			}

			const questionObj = await Question.findByIdAndUpdate(id, {
				question,
				submitedBy: loggedInUserId,
			});

			response.json({
				isSuccess: true,
				message: "Question has been  Update Successfully",
			});
		}
	} catch (error) {
		_logger.error(error);
	}
};

/**
 * Question Service
 * @param {}
 * @service  Question Service
 * @returns {List<QuestionViewModel>}
 *  */
const getAllSubmittedQuestionsByUserId = async (request, response) => {
	try {
		const loggedInUserId = _currentUserService(request, response);
		const questions = await Question.find({ submittedBy: loggedInUserId }).sort({ createdAt: -1 });

		let questionViewModel = [];

		for (item of questions) {
			questionViewModel.push({
				id: item._id,
				question: item.question,
				isAnswered: item.isAnswered,
				answerText: item.isAnswered ? item.answerText : "Not Answered Yet",
				isActive: item.isActive,
			});
		}

		response.json(questionViewModel);
	} catch (error) {
		_logger.error(error);
	}
};

/**
 * Question Service
 * @param {questionViewModel}
 * @service  Question Service
 * @returns {Promise<ResultViewModel>}
 *  */
const answerQuestion = async (request, response) => {
	try {
		const { id, answerText } = request.body;
		const loggedInUserId = _currentUserService(request);

		const question = await Question.findById(id);

		if (!question) {
			response.json({
				isSuccess: false,
				message: "Cannot Find Question",
			});
		}

		const questionObj = await Question.findByIdAndUpdate(id, {
			answerText,
			isAnswered: true,
			answeredBy: loggedInUserId,
		});

		response.json({
			isSuccess: true,
			message: "Answer Saved SuccessFully",
		});
	} catch (error) {
		_logger.error(error);
		response.json({
			isSuccess: false,
			message: "Error has been Occured please try again",
		});
	}
};

/**
 * Question Service
 * @param {id}
 * @service  Question Service
 * @returns {Promise<questionViewModel>}
 *  */

const getQuestionById = async (request, response) => {
	try {
		const { id } = request.params;
		const question = await Question.findById(id).populate("answeredBy", ["fullName", "email"]);

		if (!question) {
			response.json({
				isSuccess: false,
				message: "Cannot Find Question",
			});
		}
		const questionViewModel = {
			id: question._id,
			question: question.question,
			answerText: question.isAnswered ? question.answerText : "Not Answered Yet",
			isAnswered: question.isAnswered,
			answeredBy: question.isAnswered ? question.answeredBy : null,
		};

		response.json(questionViewModel);
	} catch (error) {
		_logger.error(error);
	}
};

/**
 * Question Service
 * @param {id}
 * @service  Question Service
 * @returns {Promise<ResponseViewModel>}
 *  */

const deleteQuestionById = async (request, response) => {
	try {
		const { id } = request.params;
		const question = await Question.findById(id);

		if (!question) {
			response.json({
				isSuccess: false,
				message: "Cannot Find Question",
			});
		}

		await Question.findByIdAndDelete(id);

		response.json({
			isSuccess: true,
			message: "Question Deleted SuccessFully",
		});
	} catch (error) {
		_logger.error(error);
		response.json({
			isSuccess: false,
			message: "Error has been Occured please try again",
		});
	}
};
module.exports = {
	submitQuestion,
	getAllSubmittedQuestionsByUserId,
	answerQuestion,
	getQuestionById,
	deleteQuestionById,
};
