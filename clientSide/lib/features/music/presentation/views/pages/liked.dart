import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone_fr/core/data/datasources/spotify_api.dart';
import 'package:spotify_clone_fr/features/auth/data/datasources/shared_prefs.dart';
import 'package:spotify_clone_fr/features/music/data/providers/albums_provider.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/logout.dart';

import 'package:spotify_clone_fr/features/music/presentation/views/pages/songs.dart';
import 'package:spotify_clone_fr/features/music/data/models/album.dart';

class liked_page extends ConsumerWidget {
  const liked_page({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
  
    final AlbumsState = ref.watch(albums_provider);
  
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
            ),
            const ListTile(
              leading: Icon(Icons.search),
              title: Text("Search"),
            ),
            const ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Liked"),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const logout()));
              },
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
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
              AlbumsState.when(data: (albums){
                return SizedBox(
                    height: 700,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: albums.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Songs(
                                          album: albums[index],
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
                                          albums[index].image),
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
                                      albums[index].name,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.download_for_offline_rounded,
                                          color: Colors.green,
                                        ),
                                        Text(
                                            " Album by ${albums[index].artist}"),
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
              }, error: (error,st){
                return Text("heyy");
              }, loading: (){
                return  const Center(child: CircularProgressIndicator());
              })
            ],
          ),
        ),
      ),
    );
  }
}
