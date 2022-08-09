import 'dart:async';

import 'package:car_helper/entities/order.dart';
import 'package:car_helper/resources/api_order_create.dart';
import 'package:car_helper/screens/home/index.dart';
import 'package:car_helper/screens/home/new_order.dart';
import 'package:car_helper/screens/order/detail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:car_helper/entities/car.dart';


class OrderCreateArgs {
  Map<int, Map<String, dynamic>> servicesMaps = {};

  OrderCreateArgs({required this.servicesMaps});
}

class OrderNew extends StatefulWidget {
  const OrderNew({Key? key}) : super(key: key);

  @override
  State<OrderNew> createState() => _OrderNewState();
}

class _OrderNewState extends State<OrderNew> {
  String authToken = "";
  String customerComment = "";
  String pickUpAddress = "";


  // final Map<int, Map<String, dynamic>> _servicesMap = {};

  @override
  Widget build(BuildContext context) {
    loadFromStorage();
    final args = ModalRoute.of(context)!.settings.arguments as OrderCreateArgs;

    final services = args.servicesMaps;

    FocusManager.instance.primaryFocus?.unfocus();

    List<Car> carList = [];


    // for (final i in services) {
    //   _servicesMap[i.id] = {"checked": false, "obj": i};
    //  }

    return Scaffold(
      appBar: AppBar(title: const Text("Создание заказа")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Форма заказа",
              style: TextStyle(fontSize: 34),
            ),
            const Text(
              "Все заявки обрабатываются в течении 2х часов, начинаем выполнять на следующий день, чтобы заранее могли забронировать очередь в СТО",
              style: TextStyle(fontSize: 15),
            ),
            Card(
              child: ExpansionTileCard(
                title: const Text('Выбранные услуги'),
                children: <Widget>[
                  const Divider(
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          // horizontal: 16.0,
                          // vertical: 8.0,
                          ),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 5),
                          for (var item in servicesMap.values.toList())
                            if (item["checked"] == true)
                              Text('${item["obj"].title}'),

                          // const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top:8.0, bottom: 8.0),
              for (car in carList)
              child: Text("Выберите Авто:"),
            ),
            const Padding(
              padding: EdgeInsets.only(top:8.0, bottom: 8.0),
              child: Text("Адрес откуда забрать авто:"),
            ),
            SizedBox(
              height: 40,
              child: TextFormField(
                onChanged: (text) => {pickUpAddress = text},
                autofocus: true,
                keyboardType: TextInputType.streetAddress,

                decoration: InputDecoration(
                  labelText: "Название улицы, номер дома",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      )),
                ),
                initialValue: pickUpAddress,
                validator: (value) {
                  if (value?.length != 12) {
                    return "Не больше 50 символов";
                  }
                  return null;
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top:8.0, bottom: 8.0),
              child: Text("Выберите удобное для Вас время:"),
            ),
            const Padding(
              padding: EdgeInsets.only(top:8.0, bottom: 8.0),
              child: Text("тут какой-то пикер"),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(top:8.0, bottom: 8.0),
              child: Text("Пожелания/Комментарии"),
            ),
            TextField(
              onChanged: (text) {
                customerComment = text;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _createOrder(services).then((order) {
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
      ),
    );
  }

  Future<String> loadFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    authToken = pf.getString("auth_token") ?? "";
    return Future.value("Ok");
  }

  Future<Order?> _createOrder(
    Map<int, Map<String, dynamic>> checkedServices,
  ) async {
    final List<int> services = [];
    checkedServices.forEach((id, info) {
      if (info["checked"] == true) {
        // debugPrint(services);
        services.add(id);
      }
    });

    final response =
        await createOrder(authToken, services, customerComment, pickUpAddress);
    debugPrint("comment: $customerComment");
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
