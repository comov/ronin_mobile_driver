import 'dart:convert';

import 'package:car_helper_driver/entities/api.dart';
import 'package:car_helper_driver/main.dart';
import 'package:http/http.dart' as http;

class AuthResponse {
  final int statusCode;

  final AuthData? auth;
  final ApiErrorResponse? error;

  const AuthResponse({required this.statusCode, this.auth, this.error});
}

Future<AuthResponse> auth(String phoneNumber, String otp) async {
  final response = await http.post(
    Uri.parse("$backendURL/api/v1/auth?phone=$phoneNumber&otp=$otp"),
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
