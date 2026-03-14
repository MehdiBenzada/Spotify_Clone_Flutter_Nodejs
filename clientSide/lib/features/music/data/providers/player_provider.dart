import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone_fr/features/music/data/models/PlayerState.dart';
import 'package:spotify_clone_fr/features/music/data/models/song.dart';

final PlayerProvider = NotifierProvider<PlayerNotifier, Playerstate>(() {
  return PlayerNotifier();
});

class PlayerNotifier extends Notifier<Playerstate> {
  @override
  Playerstate build() {
    final player = AudioPlayer();
    ref.onDispose(() => player.dispose());
    return Playerstate(
      currentSong: null,
      queue: [],
      currentIndex: 0,
      audioPlayer: player,
      isPlaying: false,
    );
  }

  Future<void> playSong(Song song, List<Song> queue, int index) async {
    final player = state.audioPlayer;
    state = Playerstate(
      currentSong: song,
      queue: queue,
      currentIndex: index,
      audioPlayer: player,
      isPlaying: true,
    );
    await player.setUrl(song.url);
    await player.play();
  }

  Future<void> pauseSong() async {
    await state.audioPlayer.pause();
    state = Playerstate(
      currentSong: state.currentSong,
      queue: state.queue,
      currentIndex: state.currentIndex,
      audioPlayer: state.audioPlayer,
      isPlaying: false,
    );
  }

  Future<void> resume() async {
    await state.audioPlayer.play();
    state = Playerstate(
      currentSong: state.currentSong,
      queue: state.queue,
      currentIndex: state.currentIndex,
      audioPlayer: state.audioPlayer,
      isPlaying: true,
    );
  }

  Future<void> next() async {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.queue.length) return;
    final nextSong = state.queue[nextIndex];
    await state.audioPlayer.setUrl(nextSong.url);
    await state.audioPlayer.play();
    state = Playerstate(
      currentSong: nextSong,
      queue: state.queue,
      currentIndex: nextIndex,
      audioPlayer: state.audioPlayer,
      isPlaying: true,
    );
  }

  Future<void> prev() async {
    final prevIndex = state.currentIndex - 1;
    if (prevIndex < 0) return;
    final prevSong = state.queue[prevIndex];
    await state.audioPlayer.setUrl(prevSong.url);
    await state.audioPlayer.play();
    state = Playerstate(
      currentSong: prevSong,
      queue: state.queue,
      currentIndex: prevIndex,
      audioPlayer: state.audioPlayer,
      isPlaying: true,
    );
  }
}
