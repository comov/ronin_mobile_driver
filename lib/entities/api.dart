class ApiErrorResponse {
  final String error;
  final String message;

  const ApiErrorResponse({required this.error, required this.message});

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      error: json["error"],
      message: json["message"],
    );
  }
}

class AuthData {
  final String token;
  final String refreshKey;

  const AuthData({required this.token, required this.refreshKey});

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(token: json["token"], refreshKey: json["refresh_key"]);
  }
}
