import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone_fr/features/music/data/models/song.dart';

class Playerstate {
  final Song? song;
  final AudioPlayer audioPlayer;
  final bool isPlaying;
  final String? currentSong;
  Playerstate({required this.song, required this.audioPlayer, required this.isPlaying,required this.currentSong});
  }