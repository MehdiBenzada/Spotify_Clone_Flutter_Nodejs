 

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone_fr/core/data/datasources/spotify_api.dart';

 

import 'package:spotify_clone_fr/features/music/data/models/album.dart';
import 'package:spotify_clone_fr/features/music/data/models/song.dart';
import 'package:spotify_clone_fr/features/music/data/providers/albumSongsProvider.dart';
import 'package:spotify_clone_fr/features/music/data/providers/albums_provider.dart';
import 'package:spotify_clone_fr/features/music/data/providers/player_provider.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/songPlayer.dart';

class Songs extends ConsumerStatefulWidget {
  const Songs({
    super.key,
    
    required this.album,
  });
  final Album album;
  @override
  ConsumerState<Songs> createState() => _SongsState();
}

class _SongsState extends ConsumerState<Songs> {

  
  bool isLiked = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    
   
    checkInitialLikedStatus();
  }

  Future<void> checkInitialLikedStatus() async {
    isLiked = await Spotify.checkIfLiked(widget.album.name);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 400.0,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.album.image,
                fit: BoxFit.fill,
                width: 60,
                height: double.infinity,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.album.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Image(
                        height: 30,
                        width: 30,
                        image: AssetImage("lib/core/assets/images/spotify.png"),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.album.artist,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        "Album",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "2018",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          widget.album.image,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 60,
                        ),
                      ),
                      const SizedBox(width: 20),
                      isLoading
                          ? const CircularProgressIndicator()
                          : IconButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (isLiked) {
                                  await  Spotify.removeFromFavAlbum(widget.album.name);
                                } else {
                                  await Spotify.addToFav(widget.album.name);
                                }
                                setState(() {
                                  isLiked = !isLiked;
                                  isLoading = false;
                                });
                              },
                              icon: const Icon(Icons.star),
                              color: isLiked ? Colors.green : Colors.white,
                            ),
                      const SizedBox(width: 20),
                      const Icon(Icons.download_for_offline_rounded,
                          color: Colors.white),
                      const SizedBox(width: 20),
                      const Icon(Icons.more_horiz_outlined,
                          color: Colors.white),
                      const Spacer(),
                      const Icon(Icons.shuffle, size: 50, color: Colors.white),
                      const SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
           ref.watch(albumSongsProvider).when(data:(data) {
            return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final Song currentSong = data[index];
                        return GestureDetector(
                          onTap: () {
                            ref.read(PlayerProvider.notifier).playSong();
                          },
                          child: ListTile(
                            title: Text(currentSong.name,
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(widget.album.artist,
                                style: const TextStyle(color: Colors.white70)),
                            trailing:
                                const Icon(Icons.more_horiz, color: Colors.white),
                          ),
                        );
                      },
                      childCount: data.length,
                    ),
                  );





             
           } , error: (error, stackTrace) {
              return SliverFillRemaining(
                    child: Text(
                        "An error occurred and the error is ${error}"),
                  );
           }, loading: () {
             return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
           },)
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 24, 24, 24),
      bottomNavigationBar: MiniPlayer(),
    );
  }

  
}
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(PlayerProvider);
    final song = player.currentSong;

    if (song == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        // TODO: open full player with showModalBottomSheet
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // Album art
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                "https://firebasestorage.googleapis.com/v0/b/spotify-8aec7.appspot.com/o/photos%2Fjl8brk6wsjr31.jpg?alt=media&token=a5a56939-7aae-4aaa-b59e-ce81c1cec6d5",
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Song info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Carousel",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Travis Scott",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Play/pause button
            StreamBuilder<PlayerState>(
              stream: player.audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return IconButton(
                  icon: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    if (playing) {
                      ref.read(PlayerProvider.notifier).pauseSong();
                    } else {
                      ref.read(PlayerProvider.notifier).resume();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}