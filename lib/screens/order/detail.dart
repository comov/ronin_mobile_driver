import 'package:car_helper/entities.dart';
import 'package:car_helper/screens/mixins.dart';
import 'package:flutter/material.dart';


class OrderDetailArguments {
  final Order order;

  OrderDetailArguments({required this.order});
}

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  String authToken = "";

  final Map<int, Map<String, dynamic>> _checkedServices = {};

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrderDetailArguments;
    final order = args.order;

    return Scaffold(
      appBar: AppBar(title: const Text("Создание заказа")),
      body: Column(
        children: [
          Text("id: ${order.id}"),
          Text("createdAt: ${order.createdAt}"),
          Text("modifiedAt: ${order.modifiedAt}"),
          Text("status: ${getOrderStatusText(order.status!)}"),
          Text("customerId: ${order.customerId}"),
          Text("carId: ${order.carId}"),
          Text("driverId: ${order.driverId}"),
          Text("managerId: ${order.managerId}"),
          Text("services: ${order.services}"),
        ],
      ),
    );
  }
}
