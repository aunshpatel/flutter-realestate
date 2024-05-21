import 'dart:convert';
import 'package:http/http.dart' as http;
import 'consts.dart';


Future<List<dynamic>> fetchSellListForShowing() async {
  final List<dynamic> data;
  final response = await http.get(Uri.parse('$apiLinkConstant/listing/get?type=sell&limit=4'));
  if (response.statusCode == 200) {
    data = json.decode(response.body);
    print(data);
  } else {
    data = [];
    print('Failed to fetch data: ${response.statusCode}');
  }
  return data;
}

Future<List<dynamic>> fetchRentListForShowing() async {
  final List<dynamic> data;
  final response = await http.get(Uri.parse('$apiLinkConstant/listing/get?type=rent&limit=4'));
  if (response.statusCode == 200) {
    data = json.decode(response.body);
    print(data);
  } else {
    data = [];
    print('Failed to fetch data: ${response.statusCode}');
  }
  return data;
}

Future<List<dynamic>> fetchDiscountListForShowing() async {
  final List<dynamic> data;
  final response = await http.get(Uri.parse('$apiLinkConstant/listing/get?discount=true&limit=4'));
  if (response.statusCode == 200) {
    data = json.decode(response.body);
    print(data);
  } else {
    data = [];
    print('Failed to fetch data: ${response.statusCode}');
  }
  return data;
}

//Below API gets all listings of a logged in user
Future<List<dynamic>> individualUserListing() async {
  final List<dynamic> data;
  final response = await http.get(Uri.parse('$apiLinkConstant/user/listings/$currentUserID'));
  if (response.statusCode == 200) {
    data = json.decode(response.body);
  } else {
    data = [];
    print('Failed to fetch data: ${response.statusCode}');
    print('${response.body}');
  }
  return data;
}