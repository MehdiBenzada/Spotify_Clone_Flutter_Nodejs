import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone_fr/features/music/data/models/song.dart';

class Playerstate {
  final Song? currentSong;
  final List<Song> queue;
  final int currentIndex;
  final AudioPlayer audioPlayer;
  final bool isPlaying;

  Playerstate({
    required this.currentSong,
    required this.queue,
    required this.currentIndex,
    required this.audioPlayer,
    required this.isPlaying,
  });
}
