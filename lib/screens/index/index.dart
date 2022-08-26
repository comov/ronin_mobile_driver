import 'package:car_helper/entities/car.dart';
import 'package:car_helper/entities/order.dart';
import 'package:car_helper/entities/service.dart';
import 'package:car_helper/entities/user.dart';
import 'package:car_helper/screens/authorization/sign_in_screen.dart';
import 'package:car_helper/screens/index/main.dart';
import 'package:car_helper/screens/index/orders.dart';
import 'package:car_helper/screens/index/profile.dart';
import 'package:car_helper/screens/index/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String homeIcon = "assets/images/icon/TabBarMain.svg";
const String servicesIcon = "assets/images/icon/TabBarServices.svg";
const String ordersIcon = "assets/images/icon/TabBarOrders.svg";
const String profileIcon = "assets/images/icon/TabBarProfile.svg";

class HomeArgs {
  final int initialState;
  final Order? newOrder;

  HomeArgs({required this.initialState, this.newOrder});
}

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> with MainState {
  String authToken = "";
  String phoneNumber = "";
  String refreshKey = "";

  Profile? profile;
  List<Car> carList = [];

  int _selectedBottom = 0;
  Map<int, List> widgetOptions = {};

  List<Service> selectedServices = [];

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TexInput.hide');
    super.initState();

    widgetOptions = {
      0: ["Главная", renderMain],
      1: ["Услуги", renderOrders],
      2: ["Заказы", bottomOrders],
      3: ["Профиль", bottomProfile],
    };
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedBottom = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    // todo: need to implement
    // var args = ModalRoute.of(context)!.settings.arguments;
    // debugPrint("args $args");
    // if (args != null) {
    //   final homeArgs = args as HomeArgs;
    //   _selectedIndex = homeArgs.initialState;
    //   if (homeArgs.newOrder != null) {
    //     orders = [homeArgs.newOrder!, ...orders];
    //   }
    //   args = null;
    // }

    return FutureBuilder<String>(
      future: loadInitialData(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: Text("Загрузка...")),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Ошибка при загрузке приложения :("),
                  Text("${snapshot.error}"),
                ],
              ),
            ),
          );
        }

        switch (snapshot.data!) {
          case "tokenNotFound":
            {
              debugPrint("authToken is empty: $authToken");
              return const SignIn();
            }
          case "tokenExpired":
            {
              debugPrint("authToken is expired: $authToken");
              return const SignIn();
            }
        }
        return Scaffold(
          // appBar: AppBar(
          //   title: Text(widgetOptions[_selectedBottom]![0]),
          // ),
          body: widgetOptions[_selectedBottom]![1](context),
          bottomNavigationBar: BottomNavigationBar(
            // backgroundColor: Colors.white10,
            // elevation: 0,
            // iconSize: 24,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            // showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  homeIcon,
                  color: Colors.grey,
                ),
                activeIcon: SvgPicture.asset(
                  homeIcon,
                  color: Colors.black,
                ),
                label: "Главная",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  servicesIcon,
                  color: Colors.grey,
                ),
                activeIcon: SvgPicture.asset(
                  servicesIcon,
                  color: Colors.black,
                ),
                label: "Новый заказ",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  ordersIcon,
                  color: Colors.grey,
                ),
                activeIcon: SvgPicture.asset(
                  ordersIcon,
                  color: Colors.black,
                ),
                label: "Заказы",
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  profileIcon,
                  color: Colors.grey,
                ),
                activeIcon: SvgPicture.asset(
                  profileIcon,
                  color: Colors.black,
                ),
                label: "Профиль",
              ),
            ],
            currentIndex: _selectedBottom,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }

  Future<String> loadInitialData() async {
    final pf = await SharedPreferences.getInstance();

    authToken = pf.getString("auth_token") ?? "";
    phoneNumber = pf.getString("phone_number") ?? "";
    refreshKey = pf.getString("refresh_key") ?? "";

    if (authToken == "") {
      return Future.value("tokenNotFound");
    }
    return Future.value("Ok");
  }
}
