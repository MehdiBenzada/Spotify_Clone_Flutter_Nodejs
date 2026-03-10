import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone_fr/features/music/data/providers/liked_albums_provider.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/liked.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/search.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/homePage.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/songs.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  static final List<Widget> _pages = <Widget>[
      home_page(),
    search_Page(),
    liked_page(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      ref.invalidate(likedAlbumsProvider);
    }
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    if (index == 2) {
      ref.invalidate(likedAlbumsProvider);
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniPlayer(),
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Liked"),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          
          ),
        ],
      ),
      
    );
  }
}



