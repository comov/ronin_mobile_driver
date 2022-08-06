import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin DebugMixin {
  void printStorage(String className) async {
    final pf = await SharedPreferences.getInstance();

    final phoneNumber = pf.getString("phone_number") ?? "";
    debugPrint("Storage in $className: phoneNumber=$phoneNumber");

    final authToken = pf.getString("auth_token") ?? "";
    debugPrint("Storage in $className: authToken=$authToken");

    final refreshKey = pf.getString("refresh_key") ?? "";
    debugPrint("Storage in $className: refreshKey=$refreshKey");
  }
}

mixin CategoriesMixin {
  final LocalStorage storage = LocalStorage("localstorage_app");

  void addCategoriesToLocalStorage(Object? categories) {
    final categoriesJson = jsonEncode(categories);
    storage.setItem("categories", categoriesJson);
  }

  getCategoriesFromLocalStorage() {
    final categoriesJson = storage.getItem("categories");
    return jsonDecode(categoriesJson);
  }
}
