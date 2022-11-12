const express = require("express");
const router = express.Router();

const { saveUser } = require("../api/user.api");

//@route POST api/user/
//@description Save User
router.post("/", saveUser);
module.exports = router;
