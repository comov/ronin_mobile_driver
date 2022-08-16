import 'dart:convert';

import 'package:car_helper/entities/api.dart';
import 'package:car_helper/entities/category.dart';
import 'package:car_helper/main.dart';
import 'package:http/http.dart' as http;

class CategoryListResponse {
  final int statusCode;

  final List<Category> categories;
  final ApiErrorResponse? error;

  const CategoryListResponse({
    required this.statusCode,
    required this.categories,
    this.error,
  });

  parseJson(List<dynamic> jsonList) {
    for (final item in jsonList) {
      categories.add(Category.fromJson(item));
    }
  }
}

Future<CategoryListResponse> getCategories(String authToken) async {
  final response = await http.get(
    Uri.parse("$backendURL/api/v1/services"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Bearer $authToken",
    },
  );
  final res = CategoryListResponse(
    statusCode: response.statusCode,
    categories: [],
  );
  if (response.statusCode == 200) {
    res.parseJson(jsonDecode(response.body));
  }
  return res;
}
