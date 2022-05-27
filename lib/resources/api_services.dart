import 'dart:convert';

import 'package:car_helper/entities.dart';
import 'package:http/http.dart' as http;

Future<List<ServiceWithCategory>> getServices(String authToken) async {
  final response = await http.get(
    Uri.parse("https://stage.i-10.win/api/v1/services"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Bearer $authToken",
    },
  );
  if (response.statusCode == 200) {
    return listOfCategoriesFromJson(jsonDecode(response.body));
  }
  return [];
}
