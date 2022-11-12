const express = require("express");
const router = express.Router();

const { login } = require("../api/auth.api");

//@route POST api/auth/
//@description Save User
router.post("/", login);

module.exports = router;
