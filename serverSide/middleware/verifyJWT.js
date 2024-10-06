require('dotenv').config();
const jwt = require('jsonwebtoken')

const verifyJWT = (req,res,next)=>{
    const authHeader = req.headers.authorization;
    if (!authHeader) return res.status(401).json({'message': 'missing token'})
    const token = authHeader.split(' ')[1];
    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err,decoded)=>{
        if (err) return res.status(403).json({'message': 'invalid token'})
        req.user= decoded.username
        next()

})}
module.exports = verifyJWT