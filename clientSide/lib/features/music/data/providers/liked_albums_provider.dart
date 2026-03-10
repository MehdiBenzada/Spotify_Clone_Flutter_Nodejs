import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone_fr/core/data/datasources/spotify_api.dart';
import 'package:spotify_clone_fr/features/music/data/models/album.dart';

final likedAlbumsProvider =
    AsyncNotifierProvider<LikedAlbumsNotifier, List<Album>>(() {
  return LikedAlbumsNotifier();
});

class LikedAlbumsNotifier extends AsyncNotifier<List<Album>> {
  @override
  Future<List<Album>> build() async {
    return Spotify.getLikedAlbums();
  }
}
