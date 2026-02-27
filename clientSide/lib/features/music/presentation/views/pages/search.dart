 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
import 'package:spotify_clone_fr/core/data/datasources/spotify_api.dart';
import 'package:spotify_clone_fr/features/auth/data/providers/search_provider.dart';
import 'package:spotify_clone_fr/features/music/data/models/album.dart';
 
import 'package:spotify_clone_fr/features/auth/data/datasources/shared_prefs.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/songs.dart';

class search_Page extends ConsumerWidget {
  const search_Page({super.key});

 


  @override
  Widget build(BuildContext context,WidgetRef ref ) {
    
  late Future<String?> tokenFuture;
  bool found = false;
  Album album = Album(name: "", artist: "", image: "");
  TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 140,
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Row(
                children: [
                  Image(
                    height: 50,
                    image: AssetImage("lib/core/assets/images/spotify.png"),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Search",
                    style: TextStyle(fontSize: 30),
                  ),
                  Spacer(),
                  Icon(Icons.camera_alt_rounded),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  ref.read(searchProvider.notifier).state=value;
                },
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "What do you want to listen to",
                  prefixIcon: Icon(
                    size: 33,
                    Icons.search,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              print("search button pressed");
              String albumTitle = searchController.text.trim();

              final album = await Spotify.fetchAlbums(albumTitle);
              print("----------------------- below is album print");
              print(
                " this is the image ${album!.image} ",
              );
              print(
                " this is the name ${album.name} ",
              );

              setState(() {
                found = true;
                this.album = album;
              });
            },
            child: const Text("Search"),
          ),
          if (found)
            GestureDetector(

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Songs(album: album),
                  ),
                );
              },
              child: Row(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.network(
                      album.image,
                      fit: BoxFit.fill,
                    ),
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
                          fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  
}

