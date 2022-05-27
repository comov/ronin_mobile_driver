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
  String phoneNumber = "";
  String authToken = "";
  String refreshKey = "";


  void delFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    pf.remove("auth_token");
  }

  @override
  Widget build(BuildContext context) {
    printStorage("HomeScreen");
    return FutureBuilder<String>(
      future: loadFromStorage(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: Text("Загрузка...")),
          );
        }

        if (snapshot.hasError) {
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
          return const SignIn();
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Home screen")),
          body: Column(
            children: [
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
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/categories");
                  },
                child: const Text("Открыть категории"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> loadFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    phoneNumber = pf.getString("phone_number") ?? "";
    authToken = pf.getString("auth_token") ?? "";
    return Future.value("Ok");
  }
}
