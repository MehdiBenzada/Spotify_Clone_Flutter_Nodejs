const bcrypt = require('bcrypt');
const User = require('../model/user');  
const jwt = require('jsonwebtoken')

const handleNewuser = async (req, res) => {
    const { user, pw } = req.body;
    if (!user || !pw) return res.status(400).json({ 'message': 'send both username and password' });

    const duplicate = await User.findOne({ username: user }).exec();
    if (duplicate) return res.status(409).json({ 'message': 'user already exists' });

    try {
        const hashedPW = await bcrypt.hash(pw, 10);
        const result = await User.create({
            "username": user,
            "password": hashedPW
        });
        console.log(result);
        const accessToken = jwt.sign({ "username": user }, process.env.ACCESS_TOKEN_SECRET, { expiresIn: '1d' });
        const refreshToken = jwt.sign({ "username": user }, process.env.REFRESH_TOKEN_SECRET, { expiresIn: '1d' });

        res.status(201).json({ 'success': `new user ${user} created with success`,accessToken, user });

    } catch (err) {
        res.status(400).json({ 'message': err.message });
    }
};

module.exports = { handleNewuser };
