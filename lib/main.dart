import 'package:car_helper_driver/screens/authorization/auth_screen.dart';
import 'package:car_helper_driver/screens/debug_page_screen.dart';
import 'package:car_helper_driver/screens/index/checker_page.dart';
import 'package:car_helper_driver/screens/index/index.dart';
import 'package:car_helper_driver/screens/order/detail.dart';
import 'package:car_helper_driver/screens/order/more_detail.dart';
import 'package:car_helper_driver/screens/order/update_car.dart';
import 'package:car_helper_driver/screens/order/upload_photo.dart';
import 'package:car_helper_driver/screens/user/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

const sentryDSN =
    "https://406aa96bd81e421692d6233984b789fd@o1348955.ingest.sentry.io/6780852";
const backendURL = "https://stage.i-10.win";
// const backendURL = "http://192.168.88.247";


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      initialRoute: "/checkerPage",
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
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
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
          actionsIconTheme: IconThemeData(color: Colors.black, opacity: 10.0),
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
        "/index": (BuildContext context) => Index(0),
        "/checkerPage": (BuildContext context) => const CheckerPage(),
        "/auth": (BuildContext context) => const Auth(),
        "/order/detail": (BuildContext context) => const OrderDetail(),
        "/order/update_car": (BuildContext context) => const UpdateCar(),
        "/order/upload_photo": (BuildContext context) => const UploadPhoto(),
        "/order/more_detail": (BuildContext context) => const MoreOrderDetail(),
        "/user/edit_profile": (BuildContext context) => const UserEdit(),
        "/debug": (BuildContext context) => const DebugPage(),
      },
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      );
  }
}
