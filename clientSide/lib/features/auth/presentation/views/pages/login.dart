import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spotify_clone_fr/core/data/datasources/spotify_api.dart';
import 'package:spotify_clone_fr/features/auth/data/datasources/shared_prefs.dart';
import 'package:spotify_clone_fr/features/auth/data/providers/auth_provider.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/pageSlider.dart';

class login extends ConsumerWidget {
  const login({super.key});
  
  @override
  
  Widget build(BuildContext context, WidgetRef ref) {
    Color newColor = const Color.fromARGB(255, 113, 103, 103);
    bool clicked = false;
    TextEditingController emailcontroller = TextEditingController();
    TextEditingController passwordcontroller = TextEditingController();
    ref.listen(authProvider,(previous, next) {
      if(next.isSuccess){
         Navigator.push(
        context,
      MaterialPageRoute(builder: (context) => const MainPage()));
      }
     
    } ,);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            SizedBox(
              width: 105,
            ),
            Text(
              "Log in",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Email ",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
            ),
            TextField(
              controller: emailcontroller,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 64, 64, 64),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 64, 64, 64)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 211, 211, 211)),
                  )),
            ),
            const Text(
              "Password",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
            ),
            TextField(
              controller: passwordcontroller,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 64, 64, 64),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 64, 64, 64)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 211, 211, 211)),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  final email = emailcontroller.text;
                  final pw = passwordcontroller.text;

                  ref.read(authProvider.notifier).login(email, pw);

                  
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 82, 82, 82),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "login",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
