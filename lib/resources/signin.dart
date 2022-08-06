import 'dart:convert';
import 'package:car_helper/entities/api.dart';
import 'package:http/http.dart' as http;

class SignInResponse {
  final int statusCode;
  final ApiErrorResponse? error;

  const SignInResponse({required this.statusCode, this.error});
}

Future<SignInResponse> sigIn(String phoneNumber) async {
  final response = await http.post(
    Uri.parse("https://stage.i-10.win/api/v1/signin?phone=$phoneNumber"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
  );

  if (response.statusCode == 200) {
    return SignInResponse(statusCode: response.statusCode);
  }
  return SignInResponse(
    statusCode: response.statusCode,
    error: ApiErrorResponse.fromJson(jsonDecode(response.body)),
  );
}
