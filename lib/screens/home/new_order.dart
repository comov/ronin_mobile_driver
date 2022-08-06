import 'package:car_helper/entities/category.dart';
import 'package:car_helper/entities/order.dart';
import 'package:car_helper/entities/service.dart';
import 'package:car_helper/screens/order/create.dart';
import 'package:flutter/material.dart';

Widget newOrder(
  BuildContext context,
  List<Category> categories,
  List<Order> orders,
  Map<int, Map<String, dynamic>> servicesMap,
) {
  final categoriesBlock = GridView.count(
    crossAxisCount: 2,
    childAspectRatio: 1.4,
    padding: const EdgeInsets.all(20),
    children: List.generate(categories.length, (index) {
      return TextButton(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  width: double.infinity,
                  height: 100,
                  // padding: EdgeInsets.all(32),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      categories[index].title,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // style: Theme.of(context).textTheme.headline5,
              ]),
          onPressed: () async {
            _showModalBottomSheet(
              context,
              servicesMap,
              categories[index].services,
            );
          });
    }),
  );

  final _view = ListView(
    children: [
      Container(
        height: 280,
        child: categoriesBlock,
      ),
      Container(
        child: Card(
          child: Column(
            children: getSelectedServices(servicesMap),
          ),
        ),
      ),
    ],
  );

  return _view;
}

List<Widget> getSelectedServices(Map<int, Map<String, dynamic>> servicesMap) {
  return [
    for (final service in servicesMap.values)
      if (service["checked"] == true)
        Text(
            "${service["obj"].title} ${service["obj"].id} (${service["checked"]})")
  ];
}

void _showModalBottomSheet(
  BuildContext context,
  Map<int, Map<String, dynamic>> servicesMap,
  List<Service> services,
) {
  showModalBottomSheet<void>(
    context: context,
    builder: (context) {
      return ListOfServices(servicesMap: servicesMap, services: services);
    },
  );
}
