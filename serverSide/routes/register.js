const express = require('express');
const router = express.Router();
const registerController = require('../controllers/registerController')

router.post('/', registerController.handleNewuser)

module.exports = router