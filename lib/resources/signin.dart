import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignInWrongResponse {
  final String? error;
  final String? message;

  const SignInWrongResponse({this.error, this.message});

  factory SignInWrongResponse.fromJson(Map<String, dynamic> json) {
    return SignInWrongResponse(
      error: json["error"],
      message: json["message"],
    );
  }
}

Future<SignInWrongResponse> sigIn(String phoneNumber) async {
  debugPrint("sigIn: phoneNumber=$phoneNumber");
  final response = await http.post(
    Uri.parse("https://stage.i-10.win/api/v1/signin?phone=$phoneNumber"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
  );
  if (response.statusCode != 200) {
    return SignInWrongResponse.fromJson(jsonDecode(response.body));
  }
  return const SignInWrongResponse(error: "", message: "");
}
