import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthResponse {
  final String? error;
  final String? message;
  final String? token;
  final String? refreshKey;

  const AuthResponse({this.error, this.message, this.token, this.refreshKey});

  factory AuthResponse.fromWrongJson(Map<String, dynamic> json) {
    return AuthResponse(
      error: json["error"],
      message: json["message"],
      token: "",
      refreshKey: "",
    );
  }

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      error: "",
      message: "",
      token: json["token"],
      refreshKey: json["refresh_key"],
    );
  }
}

Future<AuthResponse> auth(String phoneNumber, String otp) async {
  debugPrint("auth: phoneNumber=$phoneNumber");
  debugPrint("auth: otp=$otp");

  final response = await http.post(
    Uri.parse("https://stage.i-10.win/api/v1/auth?phone=$phoneNumber&otp=$otp"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
  );
  if (response.statusCode == 200) {
    debugPrint("Response from otp is 200");
    return AuthResponse.fromJson(jsonDecode(response.body));
  }
  return AuthResponse.fromWrongJson(jsonDecode(response.body));
}
