// ignore_for_file: file_names
// import 'package:car_helper/entities/car.dart';
// // import 'package:car_helper/entities/order.dart';
// import 'package:car_helper/entities/service.dart';
// import 'package:car_helper/entities/user.dart';
// import 'package:car_helper/screens/authorization/sign_in_screen.dart';
// import 'package:car_helper/screens/index/main.dart';
// import 'package:car_helper/screens/index/orders.dart';
// import 'package:car_helper/screens/index/profile.dart';
// import 'package:car_helper/screens/index/services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// const String homeIcon = "assets/images/icon/TabBarMain.svg";
// const String servicesIcon = "assets/images/icon/TabBarServices.svg";
// const String ordersIcon = "assets/images/icon/TabBarOrders.svg";
// const String profileIcon = "assets/images/icon/TabBarProfile.svg";
//
// class HomeArgs {
//   int initialState;
//   HomeArgs({required this.initialState});
// }
//
// class IndexTest extends StatefulWidget {
//
//   const IndexTest({Key? key}) : super(key: key);
//
//
//   @override
//   State<IndexTest> createState() => _IndexState();
// }
//
// class _IndexState extends State<IndexTest> with MainState, SingleTickerProviderStateMixin {
//   String authToken = "";
//   String phoneNumber = "";
//   String refreshKey = "";
//
//   Profile? profile;
//   List<Car> carList = [];
//
//   int _selectedBottom = 0;
//   Map<int, List> widgetOptions = {};
//
//   List<Service> selectedServices = [];
//   TabController? _tabController;
//
//
//
//   @override
//   void initState() {
//     SystemChannels.textInput.invokeMethod('TexInput.hide');
//     super.initState();
//
//
//     widgetOptions = {
//       0: ["Главная", renderMain],
//       1: ["Услуги", renderOrders],
//       2: ["Заказы", bottomOrders],
//       3: ["Профиль", BottomProfile],
//     };
//     _tabController = TabController(length: widgetOptions.length, vsync: this);
//
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedBottom = index;
//       // _selectedBottom = _tabController.index;
//
//       // _tabController.index = index;
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     // todo: need to implement
//     // var args = ModalRoute.of(context)!.settings.arguments;
//     // debugPrint("args $args");
//     // if (args != null) {
//     //   HomeArgs? homeArgs = args as HomeArgs;
//     //   // _onItemTapped(homeArgs.initialState);
//     //   // _selectedBottom = homeArgs.initialState;
//     //   homeArgs = null;
//     //   args = null;
//     //   homeArgs?.initialState = 0;
//     //
//     // }
//
//     return FutureBuilder<String>(
//       future: loadInitialData(),
//       builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: Text("Загрузка...")),
//           );
//         }
//
//         if (snapshot.hasError) {
//           return Scaffold(
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Ошибка при загрузке приложения :("),
//                   Text("${snapshot.error}"),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         switch (snapshot.data!) {
//           case "tokenNotFound":
//             {
//               debugPrint("authToken is empty: $authToken");
//               return const SignIn();
//             }
//           case "tokenExpired":
//             {
//               debugPrint("authToken is expired: $authToken");
//               return const SignIn();
//             }
//         }
//         return Scaffold(
//             // appBar: AppBar(
//             //   title: Text(widgetOptions[_selectedBottom]![0]),
//             // ),
//             body: widgetOptions[_selectedBottom]![1](context),
//
//           bottomNavigationBar: BottomNavigationBar(
//
//               // backgroundColor: Colors.white10,
//               // elevation: 0,
//               // iconSize: 24,
//               selectedFontSize: 10,
//               unselectedFontSize: 10,
//               selectedItemColor: Colors.black,
//               unselectedItemColor: Colors.grey,
//               // showUnselectedLabels: true,
//               type: BottomNavigationBarType.fixed,
//               items: <BottomNavigationBarItem>[
//                 BottomNavigationBarItem(
//
//                   icon: SvgPicture.asset(
//                     homeIcon,
//                     color: Colors.grey,
//                   ),
//                   activeIcon: SvgPicture.asset(
//                     homeIcon,
//                     color: Colors.black,
//                   ),
//                   label: "Главная",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: SvgPicture.asset(
//                     servicesIcon,
//                     color: Colors.grey,
//                   ),
//                   activeIcon: SvgPicture.asset(
//                     servicesIcon,
//                     color: Colors.black,
//                   ),
//                   label: "Новый заказ",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: SvgPicture.asset(
//                     ordersIcon,
//                     color: Colors.grey,
//                   ),
//                   activeIcon: SvgPicture.asset(
//                     ordersIcon,
//                     color: Colors.black,
//                   ),
//                   label: "Заказы",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: SvgPicture.asset(
//                     profileIcon,
//                     color: Colors.grey,
//                   ),
//                   activeIcon: SvgPicture.asset(
//                     profileIcon,
//                     color: Colors.black,
//                   ),
//                   label: "Профиль",
//                 ),
//               ],
//               currentIndex: _selectedBottom,
//               onTap: (index) {_onItemTapped(index);},
//
//           ),
//
//         );
//
//       },
//     );
//   }
//
//   Future<String> loadInitialData() async {
//     final pf = await SharedPreferences.getInstance();
//
//     authToken = pf.getString("auth_token") ?? "";
//     phoneNumber = pf.getString("phone_number") ?? "";
//     refreshKey = pf.getString("refresh_key") ?? "";
//
//     if (authToken == "") {
//       return Future.value("tokenNotFound");
//     }
//     return Future.value("Ok");
//   }
// }
//
//
// Class_MyAppState extends State<MyApp> {
// @override
// void initState() {
//   super.initState();
//   var initializationSettingsAndroid =
//   new AndroidInitializationSettings('ic_launcher');
//   var initialzationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//   var initializationSettings =
//   InitializationSettings(android: initialzationSettingsAndroid);
//   flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification notification = message.notification;
//     AndroidNotification android = message.notification?.android;
//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channel.description,
//               color: Colors.blue,
//               // TODO add a proper drawable resource to android, for now using
//               //      one that already exists in example app.
//               icon: "@mipmap/ic_launcher",
//             ),
//           ));
//     }
//   });
//
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     RemoteNotification notification = message.notification;
//     AndroidNotification android = message.notification?.android;
//     if (notification != null && android != null) {
//       showDialog(
//         // context: context,
//           builder: (_) {
//             return AlertDialog(
//               title: Text(notification.title),
//               content: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [Text(notification.body)],
//                 ),
//               ),
//             );
//           });
//     }
//   });
//
//   getToken();
// }
//
//
// String token;
// getToken() async {
//   token = await FirebaseMessaging.instance.getToken();
// }
