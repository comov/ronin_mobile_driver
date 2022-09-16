import 'dart:convert';

import 'package:car_helper_driver/entities/api.dart';
import 'package:car_helper_driver/entities/order.dart';
import 'package:car_helper_driver/main.dart';
import 'package:http/http.dart' as http;

class OrderListResponse {
  final int statusCode;

  final List<Order> orders;
  final ApiErrorResponse? error;

  const OrderListResponse({
    required this.statusCode,
    required this.orders,
    this.error,
  });

  parseJson(List<dynamic> jsonList) {
    for (var item in jsonList) {
      orders.add(Order.fromJson(item));
    }
  }
}

Future<OrderListResponse> getOrders(String authToken) async {
  final response = await http.get(
    Uri.parse("$backendURL/api/v1/driver/order"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Bearer $authToken",
    },
  );
  final res = OrderListResponse(
    statusCode: response.statusCode,
    orders: [],
  );
  if (response.statusCode == 200) {
    res.parseJson(jsonDecode(response.body));
  }
  return res;
}
