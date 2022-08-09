import 'package:car_helper/entities/category.dart';
import 'package:flutter/material.dart';

mixin MainState {
  List<Category> categories = [];

  Widget renderMain(BuildContext context) {
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
}
