import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:spotify_clone_fr/core/data/datasources/spotify_api.dart';
import 'package:spotify_clone_fr/features/music/data/models/album.dart';

final textProvider = StateProvider<String>((ref){
  return "";
});
final searchProvider = AsyncNotifierProvider<SearchNotifier, Album?>(() {
  return SearchNotifier();
});
class SearchNotifier extends AsyncNotifier<Album?>{
  @override
  Future<Album?> build() async{
    final query = ref.watch(textProvider);
    if (query.isEmpty) return null;
    return Spotify.fetchAlbums(query);

  }
}