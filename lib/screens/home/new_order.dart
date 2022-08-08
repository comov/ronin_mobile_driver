import 'dart:convert';

import 'package:car_helper/entities/category.dart';
import 'package:car_helper/entities/service.dart';
import 'package:car_helper/screens/order/create.dart';
import 'package:flutter/material.dart';
import 'package:car_helper/screens/authorization/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_helper/resources/api_categories.dart';

String authToken = "";
String phoneNumber = "";
String refreshKey = "";

List<Category> categories = [];


final Map<int, Map<String, dynamic>> _servicesMap = {};

var servicesMap = _servicesMap;

Widget newOrder(
  BuildContext context,
  // List<Category> categories,
  // List<Order> orders,
  // Map<int, Map<String, dynamic>> servicesMap,
) {
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

        final view = ListView(
          children: [
            SizedBox(
              height: 280,
              child: categoriesBlock,
            ),
            Card(child: Column(

                // children: getSelectedServices(servicesMap),
                children: <Widget>[

                ])),
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
//



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
      _servicesMap[service.id] = {"checked": false, "obj": service};
    }
  }

  return Future.value("Ok");
}

