import 'package:car_helper/screens/auth_screen.dart';
import 'package:car_helper/screens/home_screen.dart';
import 'package:car_helper/screens/test_page_screen.dart';
import 'package:car_helper/screens/order_new_screen.dart';
import 'package:car_helper/screens/sign_in_screen.dart';
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
        "/debug": (BuildContext context) => const DebugPage(),
        "/test": (BuildContext context) => const TestPage(),
      },
    );
  }
}
