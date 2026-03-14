import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone_fr/core/router/main_shell.dart';
import 'package:spotify_clone_fr/features/auth/data/providers/auth_provider.dart';
import 'package:spotify_clone_fr/features/auth/presentation/views/pages/welcome.dart';
import 'package:spotify_clone_fr/features/auth/presentation/views/pages/login.dart';
import 'package:spotify_clone_fr/features/auth/presentation/views/pages/signup.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/homePage.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/search.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/liked.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/songs.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/songPlayer.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/upload.dart';
import 'package:spotify_clone_fr/features/music/data/models/album.dart';

GoRouter createRouter(WidgetRef ref, Listenable refreshListenable) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loc = state.matchedLocation;

      // Still loading — don't redirect
      if (auth.isLoading) return null;

      // After splash, always go to welcome (no auto-login)
      if (loc == '/') return '/welcome';

      // Protect app routes: must be logged in
      final isLoggedIn = auth.token != null;
      final isAuthRoute =
          loc == '/welcome' || loc == '/login' || loc == '/signup';
      if (!isLoggedIn && !isAuthRoute) return '/welcome';

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => welcome(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const login(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUp(),
      ),

      // Shell wrapping the three tabs — MiniPlayer + BottomNav persist here
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const home_page(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const search_Page(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/liked',
              builder: (context, state) => const liked_page(),
            ),
          ]),
        ],
      ),

      GoRoute(
        path: '/songs',
        builder: (context, state) {
          final album = state.extra as Album;
          return Songs(album: album);
        },
      ),
      GoRoute(
        path: '/player',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SongPlayer(),
          transitionsBuilder: (context, animation, _, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut)),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/upload',
        builder: (context, state) => const UploadSong(),
      ),
    ],
  );
}
