 
const jwt = require('jsonwebtoken')
const User = require('../model/user'); 
const bcrypt = require('bcrypt')
 

const handleLogin = async (req, res) => {
    const { user, pw } = req.body
    if (!user || !pw)
        return res.status(400).json({ ' message': 'send both username and password' })
    const foundUser = await User.findOne({ username: user }).exec()
    if (!foundUser)
        return res.status(401).json({ ' message': 'user does not exist' })

    const match = await bcrypt.compare(pw, foundUser.password)


    if (match) {
        // create token
        const accessToken = jwt.sign({ "username": user }, process.env.ACCESS_TOKEN_SECRET, { expiresIn: '1d' });
        const refreshToken = jwt.sign({ "username": user }, process.env.REFRESH_TOKEN_SECRET, { expiresIn: '1d' });
        
        res.cookie('jwt', refreshToken, { httpOnly: true, maxAge: 1000 * 60 * 60 * 24 })// 
        console.log("login success")

        return res.status(201).json({ accessToken, user })

    } else {
        return res.status(400).json({ ' message': 'incorrect password' })
    }
}
module.exports = { handleLogin }