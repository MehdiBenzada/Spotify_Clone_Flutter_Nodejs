import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:spotify_clone_fr/core/data/datasources/spotify_api.dart';
import 'package:spotify_clone_fr/features/auth/data/datasources/shared_prefs.dart';
import 'package:spotify_clone_fr/features/auth/data/models/AuthState.dart';

final authProvider= NotifierProvider<AuthNotifier,AuthState>(() {
  return AuthNotifier();
});
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
     _init();
      return AuthState(user: null, token: null, isLoading: true,isSuccess: false);
  }
  Future<void> _init()async{
     final String? token= await shared_prefs().printToken();
     final String? user= await shared_prefs().printUser();
     state = AuthState(user: user, token: token, isLoading: false,isSuccess: false);
  }
  Future<void> login(email,password)async{
    try {
      state = AuthState(user: null, token: null, isLoading: true,isSuccess: false);
    final response = await Spotify.signIn(email, password);
    
    final body= jsonDecode(response.body);
    final String accessToken = body['accessToken'];
    final String user = body['user'];
    await shared_prefs().saveToken(accessToken);
    await shared_prefs().saveUser(user);
    state = AuthState(user: user, token: accessToken, isLoading: false,isSuccess: true);
    } catch (e) {
      print(e); 
    }
    
  }
  Future<void> signup(username,pw)async{
    try {
      state = AuthState(user: null, token: null, isLoading: true,isSuccess: false);
    final response = await Spotify.signup(username, pw);

    final body= jsonDecode(response.body);
    final String accessToken = body['accessToken'];
    final String user = body['user'];
    await shared_prefs().saveToken(accessToken);
    await shared_prefs().saveUser(user);
    state = AuthState(user: user, token: accessToken, isLoading: false,isSuccess: true);
    } catch (e) {
      print(e);
    }

  }

  Future<void> logout() async {
    await shared_prefs().clearAll();
    state = AuthState(user: null, token: null, isLoading: false, isSuccess: false);
  }

}