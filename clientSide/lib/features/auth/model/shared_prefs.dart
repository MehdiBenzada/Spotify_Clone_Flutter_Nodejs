import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class shared_prefs{
 
  void saveToken(String token) async {
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  void saveUser(String user) async {
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user);
  }
  Future<String?> printToken() async {
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  Future<String?> printUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }

 
}
