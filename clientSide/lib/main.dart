import 'package:flutter/material.dart';
import 'package:spotify_clone_fr/features/auth/presentation/views/pages/login.dart';

import 'package:spotify_clone_fr/features/auth/presentation/views/pages/welcome.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/home_page.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/upload.dart';
import 'package:spotify_clone_fr/features/other/presentation/views/pages/liked.dart';
import 'package:spotify_clone_fr/features/other/presentation/views/pages/mainpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF121212),
          brightness: Brightness.dark,
          primaryColor: const Color.fromARGB(255, 24, 191, 29)),
      home: welcome(),
    );
  }
}

