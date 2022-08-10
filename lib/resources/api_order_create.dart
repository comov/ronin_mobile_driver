import 'dart:convert';

import 'package:car_helper/entities/api.dart';
import 'package:car_helper/entities/order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateOrderResponse {
  final int statusCode;

  final Order? order;
  final ApiErrorResponse? error;

  const CreateOrderResponse({required this.statusCode, this.order, this.error});
}

Future<CreateOrderResponse> createOrder(
    String authToken, List<int> services, String comment, String pickUpAddress, ) async {

  final response = await http.post(
    Uri.parse("https://stage.i-10.win/api/v1/user/order"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Bearer $authToken",
    },
    body: jsonEncode({"services": services, "comment": comment, "pick_up_address": pickUpAddress}),
  );


  if (response.statusCode == 200) {
    return CreateOrderResponse(
      statusCode: response.statusCode,
      order: Order.fromJson(jsonDecode(response.body)),
    );

  }
  debugPrint("1-3");

  return CreateOrderResponse(
    statusCode: response.statusCode,
    error: ApiErrorResponse.fromJson(jsonDecode(response.body)),
  );
}
