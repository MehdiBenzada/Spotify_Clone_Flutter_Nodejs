 
import 'package:flutter/material.dart';
 
import 'package:spotify_clone_fr/core/api/api.dart';

import 'package:spotify_clone_fr/features/auth/model/shared_prefs.dart';
 
import 'package:spotify_clone_fr/features/music/pages/songs.dart';
import 'package:spotify_clone_fr/features/music/pages/upload.dart';
import 'package:spotify_clone_fr/features/music/models/Album.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  late Future<String?> tokenFuture;
  late Future<String?> userFuture;
  late Future<List<Album>> Albums;

  @override
  void initState() {
    super.initState();

    tokenFuture = shared_prefs().printToken();
    userFuture = shared_prefs().printUser();
    Albums = Spotify.getAlbums();  
 
  }

  @override
  Widget build(BuildContext context) {
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
              FutureBuilder(
                future: userFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Text(
                    "Welcome ${snapshot.data}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 27,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: FutureBuilder(
                  future: Albums,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No albums available'));
                    }

                    List<Album> albums = snapshot.data!;

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
                                  height: double
                                      .infinity, 
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
                  },
                ),
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
