import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone_fr/features/auth/data/models/AuthState.dart';

import 'package:spotify_clone_fr/features/auth/data/models/user.dart';
import 'package:spotify_clone_fr/features/auth/data/providers/auth_provider.dart';

TextEditingController textController = TextEditingController();
User newUser = User(
  username: "",
  password: "",
);
final PageController signUpPageController = PageController();

class SignUp extends ConsumerWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            final currentPage = signUpPageController.hasClients
                ? (signUpPageController.page ?? 0).round()
                : 0;
            if (currentPage == 1) {
              signUpPageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            } else {
              context.pop();
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        automaticallyImplyLeading: false,
        title: const Text("Create Your Account"),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: signUpPageController,
        children: [
          SignupInput(
            title: "username",
            pageController: signUpPageController,
          ),
          SignupInput(
            title: "password",
            pageController: signUpPageController,
          ),
        ],
      ),
    );
  }
}

class SignupInput extends ConsumerWidget {
  const SignupInput({
    super.key,
    required this.title,
    required this.pageController,
  });

  final String title;
  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authProvider, (_, next) {
      if (next.isSuccess) context.go('/home');
    });
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
                if (title == "username") {
                  newUser.username = textController.text;
                  textController.clear();
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                } else {
                  newUser.password = textController.text;
                  ref
                      .read(authProvider.notifier)
                      .signup(newUser.username, newUser.password);
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
