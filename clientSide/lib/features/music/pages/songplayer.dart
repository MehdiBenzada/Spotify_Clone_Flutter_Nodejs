import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import 'package:spotify_clone_fr/features/music/models/Album.dart';
import 'package:spotify_clone_fr/features/music/models/Song.dart';


class SongPlayer extends StatefulWidget {
  const SongPlayer({super.key, required this.album, required this.song});
  final Song song;
  final Album album;

  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class _SongPlayerState extends State<SongPlayer> {
  late AudioPlayer _audioPlayer;
  Stream<PositionData> get _positiondataStream {
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      _audioPlayer.positionStream,
      _audioPlayer.bufferedPositionStream,
      _audioPlayer.durationStream,
      (position, bufferedPosition, duration) =>
          PositionData(position, bufferedPosition, duration ?? Duration.zero),
    );
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer()
      ..setUrl(widget.song.url);  
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Text(widget.album.name),
            const Icon(Icons.more_horiz)
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 23, right: 23),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.album.image,
                fit: BoxFit.fill,
                width: 370, 
                height: 370, 
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.song.name,
                      style: const TextStyle(
                          fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.song.artist,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300)),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            StreamBuilder(
              stream: _positiondataStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  onSeek: _audioPlayer.seek,
                );
              },
            ),
            Controls(audioPlayer: _audioPlayer),
          ],
        ),
      ),
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer});
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: 50,
            onPressed: audioPlayer.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: 50,
            onPressed: audioPlayer.pause,
          );
        } else {
          return const Icon(
            Icons.play_arrow_rounded,
            size: 50,
          );
        }
      },
    );
  }
}
