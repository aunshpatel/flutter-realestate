import 'package:http/http.dart' as http;
import 'dart:convert';
import '../consts.dart';
import '../models/user_model.dart';

//Login
class UserController {
  static Future<bool> loginUser(UserLogin user) async {
    final url = Uri.parse('$apiLinkConstant/auth/signin');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      // Login successful
      print("Login successful");
      return true;
    } else {
      // Login failed
      print("Login failed");
      return false;
    }
  }
}