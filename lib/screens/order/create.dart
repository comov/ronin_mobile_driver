import 'dart:async';

import 'package:car_helper/entities/car.dart';
import 'package:car_helper/entities/order.dart';
import 'package:car_helper/resources/api_order_create.dart';
import 'package:car_helper/resources/api_user_profile.dart';
import 'package:car_helper/screens/index/index.dart';
import 'package:car_helper/screens/index/services.dart';
import 'package:car_helper/screens/order/detail.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCreateArgs {
  Map<int, SelectedService> servicesMaps = {};

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
  List<Car> carList = [];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrderCreateArgs;

    final services = args.servicesMaps;
    FocusManager.instance.primaryFocus?.unfocus();

    return FutureBuilder<String>(
      future: loadFromStorage(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                                if (item.checked == true)
                                  Text(item.service.title),
                              // const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Column(
                    children: [
                      //возможно нужен контроллер
                      if (carList.isEmpty)
                        const Text(
                            "У вас нету добавленных авто, можете добавить тут. ссылка на страничку добавления авто")
                      else
                        const Text("Выберите Авто:"),
                      for (final car in carList)
                          Text(car.displayName())
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Column(
                    children: const [
                      Text("Выберите удобное для Вас время:"),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text("тут какой-то пикер"),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                    final List<int> selectedServices = [
                      for (final item in services.values)
                        if (item.checked == true) item.service.id
                    ];

                    _createOrder(selectedServices).then((order) {
                      if (order != null) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          "/index",
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
      },
    );
  }

  Future<String> loadFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    authToken = pf.getString("auth_token") ?? "";

    final getCarListResponse = await getCustomerCars(authToken);
    carList = getCarListResponse.cars;
    return Future.value("Ok");
  }

  Future<Order?> _createOrder(List<int> checkedServices) async {
    final response = await createOrder(
      authToken,
      checkedServices,
      customerComment,
      pickUpAddress,
    );

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
