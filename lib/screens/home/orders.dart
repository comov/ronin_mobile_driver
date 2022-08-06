import 'package:car_helper/entities/category.dart';
import 'package:car_helper/entities/order.dart';
import 'package:car_helper/screens/order/detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat("d MMMM yyyy, hh:mm");

Widget bottomOrders(
  BuildContext context,
  List<Category> categories,
  List<Order> orders,
  Map<int, Map<String, dynamic>> servicesMap,
) {
  return ListView.separated(
    padding: const EdgeInsets.all(8),
    itemCount: orders.length,
    itemBuilder: (BuildContext context, int index) {
      return SizedBox(
        height: 50,
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/order/detail",
                arguments: OrderDetailArgs(order: orders[index]),
              );
            },
            child: RichText(
                text: TextSpan(children: <InlineSpan>[
              TextSpan(text: "${orders[index].id}"),
              const WidgetSpan(
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                ),
              ),
              TextSpan(text: formatter.format(orders[index].createdAt)),
              const WidgetSpan(
                child: Padding(
                  padding: EdgeInsets.only(right: 20, left: 10),
                ),
              ),
              TextSpan(text: orders[index].status)
            ]))),
      );
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}
