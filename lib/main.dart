import 'package:car_helper/screens/auth_screen.dart';
import 'package:car_helper/screens/categories_screen.dart';
import 'package:car_helper/screens/debug_screen.dart';
import 'package:car_helper/screens/services_screen.dart';
import 'package:car_helper/screens/sign_in_screen.dart';
import 'package:car_helper/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MaterialApp title",
      initialRoute: "/debug",
      routes: {
        "/home": (BuildContext context) => const Home(),
        "/signin": (BuildContext context) => const SignIn(),
        "/auth": (BuildContext context) => const Auth(),
        "/categories": (BuildContext context) => const CategoriesList(),
        "/services_screen": (BuildContext context) => const ServicesList(),
        "/debug": (BuildContext context) => const Debug(),
      },
    );
  }
}
