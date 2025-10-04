const express = require("express");

const router= express.Router();
const UserController =require("../controllers/UserController");

//router đăng ký 

router.post("/register", UserController.register);

// router đăng nhập

router.post("/login",UserController.login);

module.exports = router;
