import 'package:car_helper/screens/authorization/auth_screen.dart';
import 'package:car_helper/screens/authorization/sign_in_screen.dart';
import 'package:car_helper/screens/home.dart';
import 'package:car_helper/screens/order/create.dart';
import 'package:car_helper/screens/order/detail.dart';
import 'package:car_helper/screens/test_page_screen.dart';
import 'package:car_helper/screens/debug_page_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CarHelpers",
      initialRoute: "/home",
      routes: {
        "/home": (BuildContext context) => const Home(),
        "/signin": (BuildContext context) => const SignIn(),
        "/auth": (BuildContext context) => const Auth(),
        "/order/new": (BuildContext context) => const OrderNew(),
        "/order/detail": (BuildContext context) => const OrderDetail(),
        "/debug": (BuildContext context) => const DebugPage(),
        "/test": (BuildContext context) => const TestPage(),
      },
    );
  }
}
