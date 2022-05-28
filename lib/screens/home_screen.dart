import 'dart:convert';

import 'package:car_helper/entities.dart';
import 'package:car_helper/resources/api_services.dart';
import 'package:car_helper/screens/order_new_screen.dart';
import 'package:car_helper/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'mixins.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with DebugMixin {
  List<Category> categories = [];
  String authToken = "";

  @override
  Widget build(BuildContext context) {
    printStorage("HomeScreen");
    return FutureBuilder<String>(
      future: loadInitialData(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: Text("Загрузка...")),
          );
        }

        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  const Text("Ошибка при загрузке приложения :("),
                  Text("${snapshot.error}"),
                ],
              ),
            ),
          );
        }

        if (authToken == "") {
          debugPrint("authToken is empty: $authToken");
          return const SignIn();
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Все категории")),
          body: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/order/new",
                      arguments: NewOrderArguments(category: categories[index]),
                    );
                  },
                  child: Text(categories[index].title),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
            const Divider(),
          ),
        );
      },
    );
  }

  Future<String> loadInitialData() async {
    final pf = await SharedPreferences.getInstance();
    authToken = pf.getString("auth_token") ?? "";
    debugPrint("authToken $authToken");

    final categoriesJson = pf.getString("categories") ?? "";
    if (categoriesJson == "") {
      final services = await getServices(authToken);
      categories = fromServicesToCategories(services);
      pf.setString("categories", jsonEncode(encodeCategories(categories)));
    } else {
      categories = decodeCategories(jsonDecode(categoriesJson));
    }

    return Future.value("Ok");
  }
}
