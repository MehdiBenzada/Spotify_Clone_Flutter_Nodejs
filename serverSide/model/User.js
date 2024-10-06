const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const userSchema = new Schema({
    username:{
        type: String,
        required: true
    },
    password:{
        type: String,
        required: true
    },
    likedAlbums: [{
        type: Schema.Types.ObjectId,
        ref: 'Album',
        required: false
    }],
    accessToken: String
})
module.exports = mongoose.model('User',userSchema);