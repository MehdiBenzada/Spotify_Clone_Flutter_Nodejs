import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone_fr/core/router/app_router.dart';
import 'package:spotify_clone_fr/features/auth/data/models/AuthState.dart';
import 'package:spotify_clone_fr/features/auth/data/providers/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class _RouterRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final _RouterRefresh _routerRefresh;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _routerRefresh = _RouterRefresh();
    _router = createRouter(ref, _routerRefresh);
  }

  @override
  void dispose() {
    _routerRefresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      // Only refresh the router for two cases:
      // 1. Initial token load completed (not a login/signup)
      if ((previous?.isLoading ?? true) && !next.isLoading && !next.isSuccess) {
        _routerRefresh.refresh();
      }
      // 2. Logout (token cleared)
      if (previous?.token != null && next.token == null && !next.isLoading) {
        _routerRefresh.refresh();
      }
    });
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF121212),
          brightness: Brightness.dark,
          primaryColor: const Color.fromARGB(255, 24, 191, 29)),
    );
  }
}
