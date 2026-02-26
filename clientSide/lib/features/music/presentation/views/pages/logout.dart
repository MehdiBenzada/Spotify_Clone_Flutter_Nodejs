import 'package:flutter/material.dart';

class logout extends StatelessWidget {
  const logout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GestureDetector(
            onTap: () {
              print("logout");
            },
            child: const Text("logout")),
      ),
    );
  }
}
