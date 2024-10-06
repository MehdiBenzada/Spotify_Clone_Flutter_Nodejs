 

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone_fr/core/api/api.dart';
import 'package:spotify_clone_fr/features/auth/model/shared_prefs.dart';
 
import 'package:spotify_clone_fr/features/music/pages/songs.dart';
import 'package:spotify_clone_fr/features/music/models/Album.dart';

class liked_page extends StatefulWidget {
  const liked_page({super.key});

  @override
  State<liked_page> createState() => _liked_pageState();
}

class _liked_pageState extends State<liked_page> {
  late Future<String?> tokenFuture;
  late Future<String?> usernameFuture;
  late Future<List<Album>> albumsFuture;

  @override
  void initState() {
    super.initState();
    usernameFuture = shared_prefs().printUser();
    tokenFuture = shared_prefs().printToken();
    albumsFuture = Spotify.getAlbums();
  }

  @override
  void didUpdateWidget(covariant liked_page oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchAlbums();
  }

  void fetchAlbums() {
    setState(() {
      albumsFuture = Spotify.getAlbums();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text("Search"),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Liked"),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
            )
          ],
        ),
      ),
      appBar: AppBar(
        leading: Container(),
        backgroundColor: const Color(0xFF121212),  
        toolbarHeight: 140,
        flexibleSpace: Builder(builder: (context) {
          return Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage("lib/core/assets/images/spotify.png"),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Your library",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.search,
                      size: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.add,
                      size: 40,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 57,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, top: 10, bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 92, 90, 90),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text("Albums"),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  Icon(Icons.arrow_drop_down_rounded),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Recents",
                    style: TextStyle(fontSize: 17),
                  ),
                  Spacer(),
                  Icon(Icons.grid_on_rounded)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: albumsFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Text("");
                  }
                  return SizedBox(
                    height: 700,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Songs(
                                          album: snapshot.data[index],
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          snapshot.data[index].image),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data[index].name,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.download_for_offline_rounded,
                                          color: Colors.green,
                                        ),
                                        Text(
                                            " Album by ${snapshot.data[index].artist}"),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}
