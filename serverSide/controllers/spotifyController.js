const Album = require('../model/Album');

const Song = require('../model/Song');
const User = require('../model/user');

const getAllAlbums = async (req, res) => {
    const albums = await Album.find();
    if (!albums) return res.status(204).json({ 'message': 'no albums found ' })
    res.json(albums)
}


const get_album_by_title = async (req, res) => {
    const AlbumTitle = req.params.title;
    if (!AlbumTitle) {
        return res.status(400).json({ 'message': 'send album title (from backend)' });
    }

    try {
        
        const regexPattern = new RegExp(AlbumTitle.replace(/\s+/g, '.*'), 'i');

        const album = await Album.findOne({
            AlbumTitle: { $regex: regexPattern }
        });

        if (!album) return res.status(404).json({ 'message': 'Album not found' });
        
        res.status(201).json({ album });
    } catch (err) {
        res.status(400).json({ 'message': err.message });
    }
};
 


const getSongsbyAlbumTitle = async (req, res) => {
    const AlbumTitle = req.params.title;
    try {

        const album = await Album.findOne({ AlbumTitle: AlbumTitle }).populate('Songs').exec();
        if (!album) return res.status(404).json({ 'message': 'Album not found' });

        console.log(album.Songs);
        res.json(album.Songs);
    } catch (err) {
        console.error(err);
        res.status(400).json({ 'message': err.message });
    }
};
const get_liked_albums = async (req, res) => {
    const { username } = req.body;
    if (!username) {
        return res.status(400).json({ 'message': 'send  username' });
    }
    try {

        const user = await User.findOne({ username: username }).populate('likedAlbums').exec();
        if (!user) return res.status(404).json({ 'message': 'user dont exist' });
        if (user.likedAlbums.length == 0) return res.status(204).json({ 'message': 'no liked albums found' });

        console.log(user.likedAlbums);
        res.json(user.likedAlbums);
    } catch (err) {
        console.error(err);
        res.status(400).json({ 'message': err.message });
    }
};


const add_album = async (req, res) => {
    const { AlbumTitle, Artist, Photo, Songs, } = req.body;
    if (!AlbumTitle || !Artist || !Photo || !Songs || !Array.isArray(Songs)) {
        return res.status(400).json({ 'message': 'send all info including songs' });
    }

    const duplicate = await Album.findOne({ AlbumTitle: AlbumTitle }).exec();
    if (duplicate) return res.status(409).json({ 'message': 'album already exists' });

    try {
        
        const songIds = [];
        for (const song of Songs) {
            const { SongTitle, Artist, Photo,url } = song;
            const newSong = new Song({ SongTitle, Artist, Photo,url });
            await newSong.save();
            songIds.push(newSong._id);
        }

      
        const album = await Album.create({
            "AlbumTitle": AlbumTitle,
            "Artist": Artist,
            "Photo": Photo,
            "Songs": songIds,
             
        });

        console.log(album);
        res.status(201).json({ album });

    } catch (err) {
        res.status(400).json({ 'message': err.message });
    }
};
const liked_album = async (req, res) => {
    const { AlbumTitle, username } = req.body;
 
    if (!AlbumTitle || !username) {
        return res.status(400).json({ message: 'Please send both username and album title' });
    }

    try {
      
        const current_album = await Album.findOne({ AlbumTitle: AlbumTitle }).exec();
        if (!current_album) {
            return res.status(409).json({ message: 'Album does not exist' });
        }

     
        const current_user = await User.findOne({ username: username }).exec();
        if (!current_user) {
            return res.status(409).json({ message: 'User does not exist' });
        }

      
        const isAlbumLiked = current_user.likedAlbums.includes(current_album._id);
        if (isAlbumLiked) {
            return res.status(409).json({ message: 'Album is already liked' });
        }

    
        current_user.likedAlbums.push(current_album._id);
        await current_user.save();

        console.log('Liked album:', current_album);
        console.log('Updated user:', current_user);

        res.status(201).json({ message: 'Album added to liked albums', user: current_user });
    } catch (err) {
      
        res.status(400).json({ message: err.message });
    }
};

const remove_liked_album = async (req, res) => {
    const { AlbumTitle, username } = req.body;

    if (!AlbumTitle || !username) {
        return res.status(400).json({ message: 'Please provide both AlbumTitle and username.' });
    }

    try {
        
        const user = await User.findOne({ username }).populate('likedAlbums');
        if (!user) return res.status(404).json({ message: 'User not found' });

        
        const likedAlbumsList = user.likedAlbums;

       
        const albumIndex = likedAlbumsList.findIndex(album => album.AlbumTitle === AlbumTitle);
        if (albumIndex === -1) {
            return res.status(404).json({ message: 'Album not found in user\'s liked albums' });
        }

     
        likedAlbumsList.splice(albumIndex, 1);

        
        user.likedAlbums = likedAlbumsList.map(album => album._id); 
        await user.save();

        res.status(200).json({ message: 'Album removed from liked albums', likedAlbums: likedAlbumsList });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};
const isliked = async (req, res) => {
    const { AlbumTitle, username } = req.body;

    if (!AlbumTitle || !username) {
        return res.status(400).json({ message: 'Please provide both AlbumTitle and username.' });
    }

    try {
    
        const user = await User.findOne({ username }).populate('likedAlbums');
        if (!user) return res.status(404).json({ message: 'User not found' });

        
        const likedAlbumsList = user.likedAlbums;

      
        const albumIndex = likedAlbumsList.findIndex(album => album.AlbumTitle === AlbumTitle);
        if (albumIndex === -1) {
            
            return res.status(404).json({ message: 'Album not found in user\'s liked albums' });
        }else{
            return res.status(201).json({ message: 'Album found in liked albums' });
        }
        

       
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};


 





const delete_album_by_title = async (req, res) => {
    const AlbumTitle = req.params.title;
    try {

        const album = await Album.findOneAndDelete({ AlbumTitle: AlbumTitle });
        if (!album) return res.status(404).json({ 'message': 'Album not found' });

        const albums = await Album.find();

        res.status(201).json({ 'success': `Album ${AlbumTitle} Deleted `, albums })
    } catch (err) {
        console.error(err);
        res.status(400).json({ 'message': err.message });
    }
};



const add_songs_album = async (req, res) => {
    const { AlbumTitle, Songs } = req.body;
    if (!AlbumTitle  ) {
        return res.status(400).json({ 'message': 'send albumtitle' });
    }
    if(!Array.isArray(Songs)){
        return res.status(400).json({ 'message': 'send array of songs' });
    }

    const current_album = await Album.findOne({ AlbumTitle: AlbumTitle }).exec();
    if (!current_album) return res.status(409).json({ 'message': 'album does not exist' });

    try {
      
        const songIds = [];
        for (const song of Songs) {
            const { SongTitle, Artist, Photo,url } = song;
            const newSong = new Song({ SongTitle, Artist, Photo,url });
            await newSong.save();
            songIds.push(newSong._id);
        }
        current_album.Songs.push(...songIds);
        await current_album.save();
 

        console.log(current_album);
        res.status(201).json({ 'success': `New songs added ${current_album} created with success` });

    } catch (err) {
        res.status(400).json({ 'message': err.message });
    }
};


 

module.exports = {
    getAllAlbums,
    add_album,
    getSongsbyAlbumTitle,
    add_songs_album,
    delete_album_by_title,
    get_album_by_title,
    liked_album,
    get_liked_albums,
    remove_liked_album,
    isliked,
    

}