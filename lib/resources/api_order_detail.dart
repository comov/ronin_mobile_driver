import 'dart:convert';

import 'package:car_helper_driver/entities/api.dart';
import 'package:car_helper_driver/entities/order.dart';
import 'package:car_helper_driver/main.dart';
import 'package:http/http.dart' as http;

class OrderDetailResponse {
  final int statusCode;

  final Order orderDetail;
  final ApiErrorResponse? error;

  const OrderDetailResponse({
    required this.statusCode,
    required this.orderDetail,
    this.error,
  });

}

class OrderAcceptResponse {
  final int statusCode;
  final ApiErrorResponse? error;

  const OrderAcceptResponse({
    required this.statusCode,
    this.error,
  });

}

Future<OrderDetailResponse> getOrderDetail(String authToken, int id) async {
  final response = await http.get(
    Uri.parse("$backendURL/api/v1/driver/order/$id"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Bearer $authToken",
    },
  );
  if (response.statusCode == 200) {
    return OrderDetailResponse(
      statusCode: response.statusCode,
      orderDetail: Order.fromJson(jsonDecode(response.body)),
    );
  }
  return OrderDetailResponse(
    statusCode: response.statusCode,
    error: ApiErrorResponse.fromJson(jsonDecode(response.body)),
    orderDetail: Order.fromJson(jsonDecode(response.body)),
  );
}



Future<OrderAcceptResponse> acceptOrder(String authToken, int orderId, String comment) async {
  final response = await http.post(
    Uri.parse("$backendURL/api/v1/driver/order/$orderId/accept"),
    headers: <String, String>{
      "Authorization": "Bearer $authToken",
    },

    body: {
      "comment": comment
    }
  );
  if (response.statusCode == 200) {
    return OrderAcceptResponse(
      statusCode: response.statusCode,
    );
  }
  return OrderAcceptResponse(
    statusCode: response.statusCode,
    error: ApiErrorResponse.fromJson(jsonDecode(response.body)),
  );
}