import 'dart:convert';

import 'package:car_helper/entities/api.dart';
import 'package:car_helper/entities/service.dart';
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
}

Future<GetServicesResponse> getServices(String authToken) async {
  final response = await http.get(
    Uri.parse("https://stage.i-10.win/api/v1/services"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Bearer $authToken",
    },
  );
  if (response.statusCode == 200) {
    final services = <Service>[];
    for (final item in jsonDecode(response.body)) {
      services.add(Service.fromJson(item));
    }
    return GetServicesResponse(
      statusCode: response.statusCode,
      services: services,
    );
  }
  return GetServicesResponse(
    statusCode: response.statusCode,
    services: [],
  );
}
