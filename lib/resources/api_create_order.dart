import 'dart:convert';

import 'package:http/http.dart' as http;

class CreateOrderResponse {
  final int? id;
  // todo: change to DateTime object
  final String? createdAt;
  // todo: change to DateTime object
  final String? modifiedAt;
  final int? status;
  final int? customerId;
  final int? carId;
  final int? driverId;
  final int? managerId;
  // todo: change to Entity
  final List<dynamic>? services;

  const CreateOrderResponse({
    this.id,
    this.createdAt,
    this.modifiedAt,
    this.status,
    this.customerId,
    this.carId,
    this.driverId,
    this.managerId,
    this.services,
  });

  factory CreateOrderResponse.fromWrongJson(Map<String, dynamic> json) {
    return const CreateOrderResponse(
      id: 0,
    );
  }

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      id: json["id"],
      createdAt: json["created_at"],
      modifiedAt: json["modified_at"],
      status: json["status"],
      customerId: json["customer_id"],
      carId: json["car_id"],
      driverId: json["driver_id"],
      managerId: json["manager_id"],
      services: json["services"],
    );
  }
}

Future<CreateOrderResponse> createOrder(
    String authToken, List<int> services) async {
  final response = await http.post(
    Uri.parse("https://stage.i-10.win/api/v1/services"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Bearer $authToken",
    },
    body: jsonEncode({"services": services}),
  );
  if (response.statusCode == 200) {
    return CreateOrderResponse.fromJson(jsonDecode(response.body));
  }
  return CreateOrderResponse.fromWrongJson(jsonDecode(response.body));
}
