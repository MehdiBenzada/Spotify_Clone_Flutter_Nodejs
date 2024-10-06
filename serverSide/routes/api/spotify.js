const express = require('express');
const router = express.Router();
const employeesController = require('../../controllers/spotifyController');
const verifyJWT = require('../../middleware/verifyJWT');
router.route('/')
    .get(verifyJWT,employeesController.getAllAlbums)
    .post(employeesController.add_album)
    
router.route('/search/:title/')
    .get(employeesController.get_album_by_title)
    .delete(employeesController.delete_album_by_title)
router.route('/liked')
    .post(employeesController.liked_album)
     
router.route('/unlike') // New POST route for unliking an album
    .post(employeesController.remove_liked_album); 
    
router.route('/isliked')
    .post(employeesController.isliked)

router.route('/liked/albums')
    .post(employeesController.get_liked_albums)
    
router.route('/:title/songs')
    .get(employeesController.getSongsbyAlbumTitle)
    
 
 
router.route('/add-songs')
    .post(employeesController.add_songs_album);

module.exports = router;