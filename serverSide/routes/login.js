const express = require('express');
const router = express.Router();
const authcontroller = require('../controllers/authcontroller');

router.post('/',authcontroller.handleLogin)

module.exports = router