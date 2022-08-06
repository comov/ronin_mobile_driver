import 'package:car_helper/entities/order.dart';
import 'package:flutter/material.dart';

class OrderDetailArgs {
  final Order order;

  OrderDetailArgs({required this.order});
}

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrderDetailArgs;
    final order = args.order;

    return Scaffold(
      appBar: AppBar(title: const Text("Создание заказа")),
      body: Column(
        children: [
          Text("id: ${order.id}"),
          Text("comment: ${order.comment}"),
          Text("status: ${order.status}"),
          Text("pickUpAddress: ${order.pickUpAddress}"),
          Text("pickUpTime: ${order.pickUpTime}"),
          // Text("createdAt: ${order.createdAt.day.toString()}"),
          Text("modifiedAt: ${order.modifiedAt}"),
          Text("car.id: ${order.car?.id}"),
          Text("car.model: ${order.car?.model}"),
          Text("driver.id: ${order.driver?.id}"),
          Text("driver.firstName: ${order.driver?.firstName}"),
          Text("driver.lastName: ${order.driver?.lastName}"),
          Text("employee.firstName: ${order.employee?.firstName}"),
          Text("employee.LastName: ${order.employee?.lastName}"),
          Text("services: ${order.services}"),
        ],
      ),
    );
  }
}
