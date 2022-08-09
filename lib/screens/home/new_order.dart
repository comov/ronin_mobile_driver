import 'dart:async';
import 'dart:convert';

import 'package:car_helper/entities/category.dart';
import 'package:car_helper/entities/service.dart';
import 'package:car_helper/resources/api_categories.dart';
import 'package:car_helper/screens/authorization/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../order/create.dart';

String authToken = "";
String phoneNumber = "";
String refreshKey = "";

List<Category> categories = [];
List<Service> selectedServices = [];

final Map<int, Map<String, dynamic>> servicesMap = {};

Widget newOrder(
  BuildContext context,
  // List<Category> categories,
  // List<Order> orders,
  // Map<int, Map<String, dynamic>> servicesMap,
) {
  final selectedServiceController = SelectedServiceController();
  selectedServiceController.setMap(servicesMap);

  final controller = Get.put(selectedServiceController);

  return FutureBuilder<String>(
      future: loadInitialData(),
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
                ],
              ),
              onPressed: () async {
                _showModalBottomSheet(
                  context,
                  servicesMap,
                  categories[index].services,
                  selectedServices,
                );
              },
            );
          }),
        );

        final view = ListView(
          children: [
            SizedBox(
              height: 280,
              child: categoriesBlock,
            ),
            Card(
              //     child: Column(
              //   // children: getSelectedServices(servicesMap),
              //   children: getSelectedServices1(selectedServices),
              // )
              child: GetBuilder<SelectedServiceController>(
                init: selectedServiceController,
                builder: (value) => Column(
                  children: <Widget>[
                    if (value.isEmpty())
                      Text(value.emptyData)
                    else
                      ElevatedButton(onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/order/new",
                          arguments: OrderCreateArgs(servicesMap: value.servicesMap.values),
                        );
                      }, child: const Text("Оформить заказ")),
                      for (var item in value.servicesMap.values.toList())
                        if (item["checked"] == true)
                          Column(children: [
                            TextButton(
                              onPressed: () {
                                controller.checked(
                                    item["obj"].id, !item["checked"]);
                              },
                              child: Text('${item["obj"].title}'),
                            ),
                          ]),


                  ],
                ),
              ),
            )
          ],
        );

        return view;
      });
}

List<Widget> getSelectedServices(Map<int, Map<String, dynamic>> servicesMap) {
  return [
    for (final service in servicesMap.values)
      if (service["checked"] == true)
        Text(
            "${service["obj"].title} ${service["obj"].id} (${service["checked"]})")
  ];
}

List<Widget> getSelectedServices1(List<Service> selectedServices) {
  return [for (var service in selectedServices) Text(service.title)];
}

void _showModalBottomSheet(
  BuildContext context,
  Map<int, Map<String, dynamic>> servicesMap,
  List<Service> services,
  List<Service> selectedServices,
) {
  showModalBottomSheet<void>(
    context: context,
    builder: (context) {
      return ListOfServices(
        servicesMap: servicesMap,
        services: services,
        selectedServices: selectedServices,
      );
    },
  );
}

Future<String> loadInitialData() async {
  final pf = await SharedPreferences.getInstance();

  var authToken = pf.getString("auth_token") ?? "";

  final categoriesJson = pf.getString("categories") ?? "";
  if (categoriesJson == "" || categoriesJson == "[]") {
    final categoriesResponse = await getCategories(authToken);
    switch (categoriesResponse.statusCode) {
      case 200:
        {
          categories = categoriesResponse.categories;
        }
        break;
      case 401:
        {
          return Future.value("tokenExpired");
        }
    }

    pf.setString("categories", jsonEncode(encodeCategories(categories)));
  } else {
    final categoriesResponse = await getCategories(authToken);
    switch (categoriesResponse.statusCode) {
      case 200:
        {
          categories = categoriesResponse.categories;
        }
        break;
      case 401:
        {
          return Future.value("tokenExpired");
        }
    }
    pf.setString("categories", jsonEncode(encodeCategories(categories)));

    categories = decodeCategories(jsonDecode(categoriesJson));
  }

  for (final category in categories) {
    for (final service in category.services) {
      servicesMap[service.id] = {"checked": false, "obj": service};
    }
  }

  return Future.value("Ok");
}

class SelectedServiceController extends GetxController {
  String emptyData = "Выберите сервисы";

  late final Map<int, Map<String, dynamic>> servicesMap;

  void setMap(Map<int, Map<String, dynamic>> map) {
    servicesMap = map;
  }

  void checked(int serviceId, bool? value) {
    servicesMap[serviceId]?["checked"] = value!;
    update();
  }

  bool isEmpty() {
    for (final service in servicesMap.values.toList()) {
      if (service["checked"] == true) {
        return false;
      }
    }
    return true;
  }
}

class ListOfServices extends StatefulWidget {
  const ListOfServices({
    Key? key,
    required this.servicesMap,
    required this.services,
    required this.selectedServices,
  }) : super(key: key);
  final Map<int, Map<String, dynamic>> servicesMap;
  final List<Service> services;
  final List<Service> selectedServices;

  @override
  State<ListOfServices> createState() => _ListOfServicesState(
        servicesMap: servicesMap,
        services: services,
        selectedServices: selectedServices,
      );
}

class _ListOfServicesState extends State<ListOfServices> {
  final Map<int, Map<String, dynamic>> servicesMap;
  final List<Service> services;
  final List<Service> selectedServices;

  _ListOfServicesState({
    required this.servicesMap,
    required this.services,
    required this.selectedServices,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SelectedServiceController());
    return SizedBox(
      height: 500,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(services[index].title),
                  value: servicesMap[services[index].id]?["checked"],
                  onChanged: (bool? value) {
                    setState(() {
                      controller.checked(services[index].id, value!);
                      // if (selectedServices.contains(services[index])) {
                      //   selectedServices.remove(services[index]);
                      //   debugPrint("exist");
                      //   debugPrint("selected: $selectedServices");
                      //   controller.removeData(services[index]);
                      // } else {
                      //   controller.addData(services[index]);
                      //
                      //   selectedServices.add(services[index]);
                      //   debugPrint("selected: $selectedServices");
                      // }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
