const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const Album = require('./Album'); 
const songSchema = new Schema({
    SongTitle: {
        type: String,
        required: true
    },
    Artist: {
        type: String,
        required: true
    },
    Photo: {
        type: String,
        required: true
    },
    Album: {
        type: Schema.Types.ObjectId,
        ref: 'Album',
        required: false
    },
    url: {
        type: String,
        required: true
    },
});

module.exports = mongoose.model('Song', songSchema);
