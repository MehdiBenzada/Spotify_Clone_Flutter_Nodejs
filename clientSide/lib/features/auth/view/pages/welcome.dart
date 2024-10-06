import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:spotify_clone_fr/features/auth/view/pages/login.dart';
import 'package:spotify_clone_fr/features/auth/view/pages/signup.dart';

class welcome extends StatelessWidget {
    welcome({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              const SizedBox(
                  height: 60,
                  width: 60,
                  child: Image(
                      image: AssetImage("lib/core/assets/images/spotify.png"))),
              const SizedBox(
                height: 15,
              ),

              const Text("Millions of songs.\n Free on Spotify.",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  SignUp(),));
                },
                child: Container(
                  
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Text(
                        "Sign up free ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),  
              const SizedBox(
                height: 10,
              ),

              const auth_button(
                photo: "smartphone",
                text: "Continue with phone number",
              ),
              const SizedBox(
                height: 10,
              ),
              const auth_button(
                photo: "google",
                text: "Continue with google",
              ),
              const SizedBox(
                height: 10,
              ),
              const auth_button(
                photo: "facebook",
                text: "Continue with Facebook",
              ),
              const SizedBox(
                height: 10,
              ),
              const auth_button(
                photo: "apple",
                text: "Continue with Apple",
              ),
              TextButton(
                onPressed: () {
                  print("Login button is pressed");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const login(),));
                },
                child: const Text(
                  "Log in",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class auth_button extends StatelessWidget {
  const auth_button({super.key, required this.text, required this.photo});
  final String text;
  final String photo;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("$text button is pressed");
      },
      child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: const Color.fromARGB(118, 128, 128, 128),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: Image(
                    fit: BoxFit.fill,
                    image: AssetImage("lib/core/assets/images/$photo.png")),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )),
    );
  }
}
