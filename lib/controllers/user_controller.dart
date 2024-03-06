import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../consts.dart';
import '../models/user_model.dart';

//Login
class UserController {
  static Future<bool> loginUser(UserLogin user) async {
    prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$apiLinkConstant/auth/signin');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      // Login successful
      var userInfo = jsonDecode(response.body);
      // prefs.setStringList('loggedInUserData', userInfo);
      prefs.setString('userID', userInfo["_id"]);
      prefs.setString('username', userInfo["username"]);
      prefs.setString('email', userInfo["email"]);
      prefs.setString('avatar_image', userInfo["avatar"]);
      print("Login successful with data: ${userInfo}");
      return true;
    } else {
      // Login failed
      print("Login failed");
      return false;
    }
  }
}