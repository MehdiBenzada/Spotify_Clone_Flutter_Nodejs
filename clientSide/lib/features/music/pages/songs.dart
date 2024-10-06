 

import 'package:flutter/material.dart';
import 'package:spotify_clone_fr/core/api/api.dart';

import 'package:spotify_clone_fr/features/auth/model/shared_prefs.dart';
 

import 'package:spotify_clone_fr/features/music/models/Album.dart';
import 'package:spotify_clone_fr/features/music/models/Song.dart';
import 'package:spotify_clone_fr/features/music/pages/songplayer.dart';

class Songs extends StatefulWidget {
  const Songs({
    super.key,
    required this.album,
  });
  final Album album;
  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  late Future<String?> tokenFuture;
  late Future<String?> usernameFuture;
  late Future<List<Song>> songsFuture;
  bool isLiked = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    usernameFuture = shared_prefs().printUser();
    tokenFuture = shared_prefs().printToken();
    songsFuture = Spotify.getSongs(widget.album.name);
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
          FutureBuilder(
            future: songsFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Text(
                      "An error occurred and the error is ${snapshot.error}"),
                );
              }
              if (snapshot.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final Song currentSong = snapshot.data[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SongPlayer(
                                  album: widget.album,
                                  song: currentSong,
                                ),
                              ));
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
                    childCount: snapshot.data.length,
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 24, 24, 24),
    );
  }

  
}