import 'package:flutter/material.dart';
 
import 'package:spotify_clone_fr/features/auth/view/pages/welcome.dart';
 

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
      home:   welcome(),
    );
  }
}
