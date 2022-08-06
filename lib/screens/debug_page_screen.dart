import 'package:car_helper/screens/authorization/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mixins.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> with DebugMixin {
  String phoneNumber = "";
  String authToken = "";
  String refreshKey = "";

  @override
  Widget build(BuildContext context) {
    printStorage("HomeScreen");
    return FutureBuilder<String>(
      future: loadFromStorage(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
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
    refreshKey = pf.getString("refresh_key") ?? "";
    return Future.value("Ok");
  }
}
