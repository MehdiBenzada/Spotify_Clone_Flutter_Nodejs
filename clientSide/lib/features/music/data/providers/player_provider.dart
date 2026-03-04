import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone_fr/features/music/data/models/PlayerState.dart';

final PlayerProvider = NotifierProvider<PlayerNotifier,Playerstate>((){
 return PlayerNotifier( );
});

class PlayerNotifier extends Notifier<Playerstate>{
  
  @override
  Playerstate build() {
    return Playerstate(song: null, audioPlayer: AudioPlayer(), isPlaying: false);
    }
  Future<void> playSong() async{
    
    await state.audioPlayer.setUrl( "https://firebasestorage.googleapis.com/v0/b/spotify-8aec7.appspot.com/o/files%2FTravis%20Scott%20-%20CAROUSEL%20(Audio).mp3%20%20%20%20%20%20%202026-2-24%202%3A20%3A49?alt=media&token=399caf08-64dd-4435-80f6-a75d0a3ce177");
    state.audioPlayer.play();
     state = Playerstate(song: null, audioPlayer: state.audioPlayer, isPlaying: true);
  }
  Future<void> pauseSong() async{
    state.audioPlayer.pause();
    state= Playerstate(song: null, audioPlayer: state.audioPlayer, isPlaying: false);
  }
  Future<void> resume() async{
    state.audioPlayer.play();
    state= Playerstate(song: null, audioPlayer:state.audioPlayer, isPlaying: true);
  }
  

}