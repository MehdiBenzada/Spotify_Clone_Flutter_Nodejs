

 
import 'package:flutter/material.dart';
 
 
import 'package:spotify_clone_fr/core/api/api.dart';
import 'package:spotify_clone_fr/features/auth/model/user.dart';

import 'package:spotify_clone_fr/features/auth/view/pages/welcome.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

TextEditingController textController = TextEditingController();
User newUser = User(
  username: "",
  password: "",
);

class _SignUpState extends State<SignUp> {
  final PageController _pageController = PageController();
  int _currentPage = 0; 

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (_currentPage == 1) {
             
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            } else if (_currentPage == 0) {
             
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        automaticallyImplyLeading: false,
        title: const Text("Create Your Account"),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          SignupInput(
            title: "username",
            pageController: _pageController,
          ),
          SignupInput(
            title: "password",
            pageController: _pageController,
          ),
        ],
      ),
    );
  }
}

class SignupInput extends StatelessWidget {
  const SignupInput({
    super.key,
    required this.title,
    required this.pageController,
  });

  final String title;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
          ),
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 64, 64, 64),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 64, 64, 64)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 211, 211, 211)),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                if (title != "last") {
                  if (title == "username") {
                    newUser.username = textController.text;
                    textController.clear();
                  } else {
                    newUser.password = textController.text;
                    Spotify.signup(newUser.username, newUser.password);
                  }
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                } else {
                    Spotify.signup(newUser.username, newUser.password);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>   welcome(),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: 40, right: 40, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 82, 82, 82),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  title == "password" ? "sign up" : "next",
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


