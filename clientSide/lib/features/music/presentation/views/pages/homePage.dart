import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spotify_clone_fr/core/data/datasources/spotify_api.dart';

import 'package:spotify_clone_fr/features/auth/data/datasources/shared_prefs.dart';
import 'package:spotify_clone_fr/features/auth/data/providers/auth_provider.dart';
import 'package:spotify_clone_fr/features/music/data/providers/albums_provider.dart';

import 'package:spotify_clone_fr/features/music/presentation/views/pages/songs.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/upload.dart';
import 'package:spotify_clone_fr/features/music/data/models/album.dart';

class home_page extends ConsumerWidget {
  const home_page({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsState = ref.watch(albums_provider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("lib/core/assets/images/spotify.png"),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UploadSong()));
            },
            child: const appBar_container(
              title: "All",
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const appBar_container(
            title: "Music",
          ),
          const SizedBox(
            width: 10,
          ),
          const appBar_container(
            title: "Podcasts",
          ),
        ]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome ${ref.watch(authProvider).user}",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 27,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: albumsState.when(data: (albums) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 60,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                    ),
                    itemCount: albums.length,
                    itemBuilder: (BuildContext context, int index) {
                      Album album = albums[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Songs(
                                        album: album,
                                      )));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                              color: Color.fromARGB(74, 158, 158, 158)),
                          child: Row(
                            children: [
                              Image.network(
                                album.image,
                                fit: BoxFit.fill,
                                width: 60,
                                height: double.infinity,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  album.name,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }, error: (e, st) {
                  return const Center(child: Text("Error"));
                }, loading: () {
                  return const Center(child: CircularProgressIndicator());
                }),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Recommended for today",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 27,
                ),
              ),
              SizedBox(
                height: 220,
                width: double.maxFinite,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                                height: 150,
                                image: AssetImage(
                                  "lib/core/assets/images/ds2.jpg",
                                )),
                            Text("Love Sicj (Deluxe)"),
                            Text("Album by Don Toliver")
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Text(
                "Recently played",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 27,
                ),
              ),
              SizedBox(
                height: 300,
                width: double.maxFinite,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                                height: 100,
                                image: AssetImage(
                                  "lib/core/assets/images/dbr.jpg",
                                )),
                            Text("Days Before Rodeo"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class appBar_container extends StatelessWidget {
  const appBar_container({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[800], borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
