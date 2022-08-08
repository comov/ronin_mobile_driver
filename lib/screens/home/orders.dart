import 'package:car_helper/entities/category.dart';
import 'package:car_helper/entities/order.dart';
import 'package:car_helper/screens/order/detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_helper/resources/api_order_list.dart';
import 'package:car_helper/screens/authorization/sign_in_screen.dart';
import 'package:car_helper/screens/home/index.dart';



final DateFormat formatter = DateFormat("d MMMM yyyy, hh:mm");

String authToken = "";
String phoneNumber = "";
String refreshKey = "";

List<Order> orders = [];


Widget bottomOrders(
  BuildContext context,
  // List<Category> categories,
  // List<Order> orders,
  // Map<int, Map<String, dynamic>> servicesMap,
) {
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
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        );
      });


}

Future<String> loadInitialData1() async {
  final pf = await SharedPreferences.getInstance();

  var authToken = pf.getString("auth_token") ?? "";
  var phoneNumber = pf.getString("phone_number") ?? "";
  var refreshKey = pf.getString("refresh_key") ?? "";

  debugPrint("auto");
  final getOrderListResponse = await getOrders(authToken);
  orders = getOrderListResponse.orders;
  debugPrint("orders: $getOrderListResponse.orders;");


  return Future.value("Ok");
}

