import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone_fr/core/data/datasources/spotify_api.dart';
import 'package:spotify_clone_fr/features/music/data/models/album.dart';

final albums_provider= AsyncNotifierProvider<AlbumsNotifier,List<Album>>((){
  return AlbumsNotifier();
});
class AlbumsNotifier extends AsyncNotifier<List<Album>> {
  @override
  Future<List<Album>> build() async {
    return Spotify.getAlbums();
  }
}
