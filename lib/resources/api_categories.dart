import 'dart:convert';

import 'package:car_helper/entities/api.dart';
import 'package:car_helper/entities/category.dart';
import 'package:http/http.dart' as http;

class GetCategoriesResponse {
  final int statusCode;

  final List<Category> categories;
  final ApiErrorResponse? error;

  const GetCategoriesResponse({
    required this.statusCode,
    required this.categories,
    this.error,
  });
}

Future<GetCategoriesResponse> getCategories(String authToken) async {
  final response = await http.get(
    Uri.parse("https://stage.i-10.win/api/v1/services"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Bearer $authToken",
    },
  );
  if (response.statusCode == 200) {
    final categories = <Category>[];
    for (final item in jsonDecode(response.body)) {
      categories.add(Category.fromJson(item));
    }
    return GetCategoriesResponse(
      statusCode: response.statusCode,
      categories: categories,
    );
  }
  return GetCategoriesResponse(
    statusCode: response.statusCode,
    categories: [],
  );
}
