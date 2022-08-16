import 'package:car_helper/screens/authorization/auth_screen.dart';
import 'package:car_helper/screens/authorization/sign_in_screen.dart';
import 'package:car_helper/screens/debug_page_screen.dart';
import 'package:car_helper/screens/index/index.dart';
import 'package:car_helper/screens/order/create.dart';
import 'package:car_helper/screens/order/detail.dart';
import 'package:car_helper/screens/test_page_screen.dart';
import 'package:car_helper/screens/user/create_car.dart';
import 'package:car_helper/screens/user/edit_car.dart';
import 'package:car_helper/screens/user/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

const sentryDSN = "https://8198951336c94b3cba51cd09a46dbac2@o1348955.ingest.sentry.io/6655166";
const backendURL = "https://stage.i-10.win";

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDSN;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );

  // or define SENTRY_DSN via Dart environment variable (--dart-define)
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CarHelpers",
      initialRoute: "/index",
      navigatorObservers: [
        SentryNavigatorObserver(),
      ],
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
        "/user/edit_car": (BuildContext context) => const EditCar(),
        "/debug": (BuildContext context) => const DebugPage(),
        "/test": (BuildContext context) => const TestPage(),
      },
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
    );
  }
}
