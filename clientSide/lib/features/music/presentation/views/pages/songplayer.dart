import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import 'package:spotify_clone_fr/features/music/data/providers/player_provider.dart';

class SongPlayer extends ConsumerStatefulWidget {
  const SongPlayer({super.key});

  @override
  ConsumerState<SongPlayer> createState() => _SongPlayerState();
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class _SongPlayerState extends ConsumerState<SongPlayer> {
  late AudioPlayer audioPlayer;

  Stream<PositionData> get _positiondataStream {
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      audioPlayer.positionStream,
      audioPlayer.bufferedPositionStream,
      audioPlayer.durationStream,
      (position, bufferedPosition, duration) =>
          PositionData(position, bufferedPosition, duration ?? Duration.zero),
    );
  }

  @override
  void initState() {
    super.initState();
    audioPlayer = ref.read(PlayerProvider).audioPlayer;
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(PlayerProvider);
    final song = playerState.currentSong;

    if (song == null) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 24, 24, 24),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon:
                  const Icon(Icons.arrow_downward_rounded, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const Text("Now Playing"),
            const Icon(Icons.more_horiz)
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 23, right: 23),
        child: Column(
          children: [
            const SizedBox(height: 50),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                song.image,
                fit: BoxFit.fill,
                width: 370,
                height: 370,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.name,
                      style: const TextStyle(
                          fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      song.artist,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            StreamBuilder(
              stream: _positiondataStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  onSeek: audioPlayer.seek,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 40),
                  onPressed: () => ref.read(PlayerProvider.notifier).prev(),
                ),
                const Controls(),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 40),
                  onPressed: () => ref.read(PlayerProvider.notifier).next(),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 24, 24, 24),
    );
  }
}

class Controls extends ConsumerWidget {
  const Controls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioPlayer = ref.read(PlayerProvider).audioPlayer;
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
            onPressed: () => ref.read(PlayerProvider.notifier).resume(),
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: 50,
            onPressed: () => ref.read(PlayerProvider.notifier).pauseSong(),
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay, size: 50),
            onPressed: () => ref.read(PlayerProvider.notifier).resume(),
          );
        }
      },
    );
  }
}
