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
      var setCookieValue = response.headers['set-cookie']?.split(';');
      token = setCookieValue![0];
      currentUserID = userInfo["_id"];
      prefs.setString('token', token);
      prefs.setString('userID', userInfo["_id"]);
      prefs.setString('username', userInfo["username"]);
      prefs.setString('email', userInfo["email"]);
      prefs.setString('avatarImage', userInfo["avatar"]);
      return true;
    } else {
      // Login failed
      print("Login failed");
      return false;
    }
  }

  static Future<bool> updateUser(UserUpdate user) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token")!;
    final url = Uri.parse('$apiLinkConstant/user/update/$currentUserID');
    Map<String, String> headers = {"Content-Type": "application/json", 'Cookie':'$token'};
    final response = await http.post(
      url,
      // headers: {"Content-Type": "application/json", 'Authorization':'Bearer $token'},
      headers: headers,
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      // Update successful
      var userInfo = jsonDecode(response.body);
      prefs.setString('username', userInfo["username"]);
      prefs.setString('email', userInfo["email"]);
      return true;
    } else {
      // Update failed
      print("Update failed");
      return false;
    }
  }
}