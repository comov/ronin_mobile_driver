import 'package:car_helper/screens/authorization/auth_screen.dart';
import 'package:car_helper/screens/authorization/sign_in_screen.dart';
import 'package:car_helper/screens/debug_page_screen.dart';
import 'package:car_helper/screens/index/index.dart';
import 'package:car_helper/screens/order/create.dart';
import 'package:car_helper/screens/order/detail.dart';
import 'package:car_helper/screens/test_page_screen.dart';
import 'package:car_helper/screens/user/create_car.dart';
import 'package:car_helper/screens/user/edit_profile.dart';
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
      initialRoute: "/index",
      theme: ThemeData(

        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        cardTheme: CardTheme(
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.black,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(Colors.black),
          fillColor: MaterialStateProperty.all(Colors.black),
          side: const BorderSide(width: 1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
          fillColor: Colors.black,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        textTheme: const TextTheme(
          labelSmall: TextStyle(color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 34,
          ),
          toolbarHeight: 35,
        ),
      ),
      routes: {
        "/index": (BuildContext context) => const Index(),
        "/signin": (BuildContext context) => const SignIn(),
        "/auth": (BuildContext context) => const Auth(),
        "/order/new": (BuildContext context) => const OrderNew(),
        "/order/detail": (BuildContext context) => const OrderDetail(),
        "/user/edit_profile": (BuildContext context) => const UserEdit(),
        "/user/create_car": (BuildContext context) => const CreateCar(),
        "/debug": (BuildContext context) => const DebugPage(),
        "/test": (BuildContext context) => const TestPage(),
      },
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
    );
  }
}
