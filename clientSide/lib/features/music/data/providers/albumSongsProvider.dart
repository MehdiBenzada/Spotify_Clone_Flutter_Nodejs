import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spotify_clone_fr/core/data/datasources/spotify_api.dart';
import 'package:spotify_clone_fr/features/music/data/models/song.dart';

final selectedAlbumProvider = StateProvider<String>((ref) => "");

final albumSongsProvider = AsyncNotifierProvider<AlbumSongsNotifier, List<Song>>(
  AlbumSongsNotifier.new,
);

class AlbumSongsNotifier extends AsyncNotifier<List<Song>> {
  @override
  Future<List<Song>> build() async {
   final albumName= ref.watch(selectedAlbumProvider);
    return Spotify.getSongs(albumName);
  }
}