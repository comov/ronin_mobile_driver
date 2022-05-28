import 'dart:convert';

import 'package:car_helper/entities/api.dart';
import 'package:car_helper/entities/user.dart';
import 'package:http/http.dart' as http;

class ProfileResponse {
  final int statusCode;

  final Profile? profile;
  final ApiErrorResponse? error;

  const ProfileResponse({required this.statusCode, this.profile, this.error});
}

Future<ProfileResponse> getProfile(String authToken) async {
  final response = await http.get(
    Uri.parse("https://stage.i-10.win/api/v1/user/profile"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Bearer $authToken",
    },
  );
  if (response.statusCode == 200) {
    return ProfileResponse(
      statusCode: response.statusCode,
      profile: Profile.fromJson(jsonDecode(response.body)),
    );
  }
  return ProfileResponse(
    statusCode: response.statusCode,
    error: ApiErrorResponse.fromJson(jsonDecode(response.body)),
  );
}
