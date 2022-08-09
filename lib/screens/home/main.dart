import 'package:car_helper/entities/category.dart';
import 'package:car_helper/screens/order/create.dart';
import 'package:flutter/material.dart';

List<Category> categories = [];

Widget bottomCategories(
  BuildContext context,
  // List<Category> categories,
  // List<Order> orders,
) {
  return ListView.separated(
    padding: const EdgeInsets.all(8),
    itemCount: categories.length,
    itemBuilder: (BuildContext context, int index) {
      return SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              "/order/new",
              // arguments: OrderCreateArgs(category: categories[index]),
            );
          },
          child: Text(categories[index].title),
        ),
      );
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}
