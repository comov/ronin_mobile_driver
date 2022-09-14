import 'dart:convert';

import 'package:car_helper_driver/entities/api.dart';
import 'package:car_helper_driver/entities/service.dart';
import 'package:car_helper_driver/main.dart';
import 'package:http/http.dart' as http;

class GetServicesResponse {
  final int statusCode;

  final List<Service> services;
  final ApiErrorResponse? error;

  const GetServicesResponse({
    required this.statusCode,
    required this.services,
    this.error,
  });

  parseJson(List<dynamic> jsonList) {
    for (final item in jsonList) {
      services.add(Service.fromJson(item));
    }
  }
}

Future<GetServicesResponse> getServices(String authToken) async {
  final response = await http.get(
    Uri.parse("$backendURL/api/v1/services"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Bearer $authToken",
    },
  );
  final res = GetServicesResponse(
    statusCode: response.statusCode,
    services: [],
  );
  if (response.statusCode == 200) {
    res.parseJson(jsonDecode(response.body));
  }
  return res;
}
