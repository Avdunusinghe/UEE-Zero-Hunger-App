const express = require("express");
const router = express.Router();

const {
	submitQuestion,
	getAllSubmittedQuestionsByUserId,
	answerQuestion,
	getQuestionById,
	deleteQuestionById,
} = require("../api/question.api");

//@route POST api/question/
//@description Save question
router.post("/", submitQuestion);

//@route GET api/question/
//@description Get questions
router.get("/", getAllSubmittedQuestionsByUserId);

//@route GET api/question/
//@description PUT questions
router.put("/", answerQuestion);

//@route GET api/question/
//@description Get question by id
router.get("/:id", getQuestionById);

//@route GET api/question/
//@description  Delete by id
router.delete("/:id", deleteQuestionById);

module.exports = router;
