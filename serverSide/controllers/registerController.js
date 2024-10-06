const bcrypt = require('bcrypt');
const User = require('../model/user');  

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

        res.status(201).json({ 'success': `new user ${user} created with success` });

    } catch (err) {
        res.status(400).json({ 'message': err.message });
    }
};

module.exports = { handleNewuser };
