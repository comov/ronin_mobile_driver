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
  String phoneNumber = "";
  String refreshKey = "";

  int _selectedIndex = 0;
  Map<int, Function> widgetOptions = {};

  @override
  void initState() {
    super.initState();
    widgetOptions = {
      0: bottomCategories,
      1: bottomProfile,
    };
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          body: Center(
            child: widgetOptions[_selectedIndex]!(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: "Категории",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Профиль",
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }

  Widget bottomCategories() {
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
                arguments: NewOrderArguments(category: categories[index]),
              );
            },
            child: Text(categories[index].title),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
      const Divider(),
    );
  }

  Widget bottomProfile() {
    return Column(
      children: [
        // todo: Need to delete phoneNumber, authToken, refreshKey from this page
        Text("phoneNumber: $phoneNumber"),
        Text("authToken: $authToken"),
        Text("refreshKey: $refreshKey"),
        ElevatedButton(
          onPressed: () {
            delFromStorage();
            Navigator.of(context).pushNamedAndRemoveUntil("/signin", (route) => false);
          },
          child: const Text("Выйти"),
        ),
      ],
    );
  }

  Future<String> loadInitialData() async {
    final pf = await SharedPreferences.getInstance();
    authToken = pf.getString("auth_token") ?? "";
    phoneNumber = pf.getString("phone_number") ?? "";
    refreshKey = pf.getString("refresh_key") ?? "";
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

  void delFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    pf.remove("auth_token");
    pf.remove("refresh_key");
  }
}
