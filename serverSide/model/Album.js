const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const albumSchema = new Schema({
    AlbumTitle:{
        type: String,
        required: true
    },
    Artist:{
        type: String,
        required: true
    },
    Photo:{
        type: String,
        required: true
    },
    Songs: [{
        type: Schema.Types.ObjectId,
        ref: 'Song',
        required: true
    }]
     
})
module.exports = mongoose.model('Album',albumSchema);