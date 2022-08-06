import 'dart:convert';

import 'package:car_helper/entities/api.dart';
import 'package:car_helper/resources/auth.dart';
import 'package:http/http.dart' as http;

Future<AuthResponse> refreshToken(String refreshToken) async {
  final response = await http.post(
    Uri.parse(
        "https://stage.i-10.win/api/v1/refresh?refresh_token=$refreshToken"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
  );

  if (response.statusCode == 200) {
    return AuthResponse(
      statusCode: response.statusCode,
      auth: AuthData.fromJson(jsonDecode(response.body)),
    );
  }
  return AuthResponse(
    statusCode: response.statusCode,
    error: ApiErrorResponse.fromJson(jsonDecode(response.body)),
  );
}