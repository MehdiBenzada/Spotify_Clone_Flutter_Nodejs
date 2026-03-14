import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone_fr/features/auth/data/providers/search_provider.dart';
import 'package:spotify_clone_fr/features/music/data/providers/albumSongsProvider.dart';

class search_Page extends ConsumerWidget {
  const search_Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);

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
                  ref.read(textProvider.notifier).state = value;
                },
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: searchState.when(
          data: (album) {
            if (album == null) return const SizedBox();
            return GestureDetector(
              onTap: () {
                ref.read(selectedAlbumProvider.notifier).state = album.name;
                context.push('/songs', extra: album);
              },
              child: Row(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.network(
                      album.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          album.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          album.artist,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => const Center(child: Text("Album not found")),
        ),
      ),
    );
  }
}