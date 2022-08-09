import 'dart:async';

import 'package:car_helper/entities/category.dart';
import 'package:car_helper/entities/order.dart';
import 'package:car_helper/resources/api_order_create.dart';
import 'package:car_helper/screens/home/index.dart';
import 'package:car_helper/screens/order/detail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCreateArgs {
  final Category category;

  OrderCreateArgs({required this.category});
}

class OrderNew extends StatefulWidget {
  const OrderNew({Key? key}) : super(key: key);

  @override
  State<OrderNew> createState() => _OrderNewState();
}

class _OrderNewState extends State<OrderNew> {
  String authToken = "";

  final Map<int, Map<String, dynamic>> _servicesMap = {};

  @override
  Widget build(BuildContext context) {
    loadFromStorage();

    final args = ModalRoute.of(context)!.settings.arguments as OrderCreateArgs;
    final services = args.category.services;

    for (final i in services) {
      _servicesMap[i.id] = {"checked": false, "obj": i};
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Создание заказа")),
      body: Column(
        children: [
          const Text("Что входит в услугу"),
          const Text("Описание того, что входит в услугу"),
          ElevatedButton(
            onPressed: () {
              // _showModalBottomSheet(context, _servicesMap);
            },
            child: const Text("Выбирете услугу"),
          ),
          ElevatedButton(
            onPressed: () {
              _createOrder(_servicesMap).then((order) {
                if (order != null) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    "/home",
                    (route) => false,
                    arguments: HomeArgs(initialState: 1, newOrder: order),
                  );
                  Navigator.pushNamed(
                    context,
                    "/order/detail",
                    arguments: OrderDetailArgs(order: order),
                  );
                }
              });
            },
            child: const Text("Создать заказ"),
          ),
        ],
      ),
    );
  }

  Future<String> loadFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    authToken = pf.getString("auth_token") ?? "";
    return Future.value("Ok");
  }

  // void _showModalBottomSheet(
  //   BuildContext context,
  //   Map<int, Map<String, dynamic>> servicesMap,
  // ) {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (context) {
  //       return ListOfServices(servicesMap: servicesMap);
  //     },
  //   );
  // }

  Future<Order?> _createOrder(
    Map<int, Map<String, dynamic>> checkedServices,
  ) async {
    final List<int> services = [];
    checkedServices.forEach((id, info) {
      if (info["checked"] == true) {
        services.add(id);
      }
    });

    final response = await createOrder(authToken, services);
    switch (response.statusCode) {
      case 200:
        {
          final order = response.order!;
          debugPrint("Заказ был создан! Order: ${order.id}");
          break;
        }
      default:
        {
          debugPrint("Ошибка при создании Заказа: ${response.statusCode}");
          debugPrint("response.error!.error=${response.error!.error}");
          debugPrint("response.error!.message=${response.error!.message}");
          break;
        }
    }
    return Future.value(response.order);
  }
}
