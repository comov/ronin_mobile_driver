import 'package:car_helper/entities/order.dart';
import 'package:car_helper/resources/api_order_list.dart';
import 'package:car_helper/screens/authorization/sign_in_screen.dart';
import 'package:car_helper/screens/order/detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final DateFormat formatter = DateFormat("d MMMM yyyy, HH:mm");
late String authToken;

List<Order> orders = [];

Widget bottomOrders(BuildContext context) {
  return FutureBuilder<String>(
    future: loadInitialData1(),
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(
          body: Center(child: Text("Загрузка...")),
        );
      }

      if (snapshot.hasError) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Ошибка при загрузке приложения :("),
                Text("${snapshot.error}"),
              ],
            ),
          ),
        );
      }

      switch (snapshot.data!) {
        case "tokenNotFound":
          {
            debugPrint("authToken is empty: $authToken");
            return const SignIn();
          }
        case "":
          {
            debugPrint("authToken is expired: $authToken");
            return const SignIn();
          }
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text("Заказы"),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 34,
          ),
        ),
        body: ListView.separated(
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
                child: Row(
                  children: [
                    Text(orders[index].id.toString()),
                    const Spacer(),
                    Text(formatter.format(orders[index].createdAt.toLocal())),
                    const Spacer(),
                    SizedBox(
                      width: 100,
                        child: Text(orders[index].status, maxLines: 2, style: const TextStyle(color: Colors.blue),)
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      );
    },
  );
}

Future<String> loadInitialData1() async {
  final pf = await SharedPreferences.getInstance();


  authToken = pf.getString("auth_token") ?? "";

  final getOrderListResponse = await getOrders(authToken);
  orders = getOrderListResponse.orders;

  return Future.value("Ok");
}
