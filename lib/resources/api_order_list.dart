import 'dart:convert';

import 'package:car_helper/entities/api.dart';
import 'package:car_helper/entities/order.dart';
import 'package:http/http.dart' as http;

List<Order> listOfOrdersFromJson(List<dynamic> jsonList) {
  List<Order> orders = [];
  for (var item in jsonList) {
    orders.add(Order.fromJson(item));
  }
  return orders;
}

Future<List<Order>> getOrders(String authToken) async {
  final response = await http.get(
    Uri.parse("https://stage.i-10.win/api/v1/user/order"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": "Bearer $authToken",
    },
  );
  if (response.statusCode == 200) {
    return listOfOrdersFromJson(jsonDecode(response.body));
  }
  return listOfOrdersFromJson(jsonDecode(response.body));
}
