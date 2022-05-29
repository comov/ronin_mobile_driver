import 'dart:convert';

import 'package:car_helper/entities.dart';
import 'package:car_helper/entities/order.dart';
import 'package:car_helper/entities/user.dart';
import 'package:car_helper/resources/api_order_list.dart';
import 'package:car_helper/resources/api_services.dart';
import 'package:car_helper/resources/api_user_profile.dart';
import 'package:car_helper/screens/order/create.dart';
import 'package:car_helper/screens/order/detail.dart';
import 'package:car_helper/screens/authorization/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeArgs {
  final int initialState;
  final Order? newOrder;

  HomeArgs({required this.initialState, this.newOrder});
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Category> categories = [];
  List<Order> orders = [];

  String authToken = "";
  String phoneNumber = "";
  String refreshKey = "";

  Profile? profile;

  int _selectedBottom = 0;
  Map<int, List> widgetOptions = {};

  @override
  void initState() {
    super.initState();
    widgetOptions = {
      0: ["Все категории", bottomCategories],
      1: ["Заказы", bottomOrders],
      2: ["Профиль", bottomProfile],
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
          case "":
            {
              debugPrint("authToken is expired: $authToken");
              return const SignIn();
            }
        }
        return Scaffold(
          appBar: AppBar(title: Text(widgetOptions[_selectedBottom]![0])),
          body: Center(
            child: widgetOptions[_selectedBottom]![1](),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white10,
            elevation: 0,
            iconSize: 26,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: "Категории",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.view_list),
                label: "Заказы",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
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

  Widget bottomCategories() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/order/new",
                arguments: OrderCreateArgs(category: categories[index]),
              );
            },
            child: Text(categories[index].title),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget bottomOrders() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: orders.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/order/detail",
                arguments: OrderDetailArgs(order: orders[index]),
              );
            },
            child: Text("${orders[index].id}"),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget bottomProfile() {
    return FutureBuilder<String>(
        future: loadInitialData(),
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
            case "":
              {
                debugPrint("authToken is expired: $authToken");
                return const SignIn();
              }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("id: ${profile!.id}"),
              const Divider(),
              Text("phone: ${profile!.phone}"),
              const Divider(),
              Text("firstName: ${profile!.firstName}"),
              const Divider(),
              Text("lastName: ${profile!.lastName}"),
              const Divider(),
              Text("createdAt: ${profile!.createdAt}"),
              const Divider(),
              Text("modifiedAt: ${profile!.modifiedAt}"),
              const Divider(),

              // todo: Need to delete phoneNumber, authToken, refreshKey from this page
              const Text("##### Хранилище приложения #####"),
              const Divider(),
              Text("phoneNumber: $phoneNumber"),
              const Divider(),
              Text("authToken: $authToken"),
              const Divider(),
              Text("refreshKey: $refreshKey"),
              const Divider(),

              const Text("##### Кнопки #####"),
              Row(),
              ElevatedButton(
                onPressed: () {
                  delFromStorage();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    "/signin",
                    (route) => false,
                  );
                },
                child: const Text("Выйти"),
              ),
            ],
          );
        });
  }

  void delFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    pf.remove("auth_token");
    pf.remove("refresh_key");
  }

  Future<String> loadInitialData() async {
    final pf = await SharedPreferences.getInstance();
    authToken = pf.getString("auth_token") ?? "";
    phoneNumber = pf.getString("phone_number") ?? "";
    refreshKey = pf.getString("refresh_key") ?? "";

    if (authToken == "") {
      return Future.value("tokenNotFound");
    }

    if (profile == null) {
      final profileResponse = await getProfile(authToken);
      switch (profileResponse.statusCode) {
        case 200:
          {
            profile = profileResponse.profile;
          }
          break;
        case 401:
          {
            return Future.value("tokenExpired");
          }
      }
    }

    final categoriesJson = pf.getString("categories") ?? "";
    if (categoriesJson == "") {
      final services = await getServices(authToken);
      categories = fromServicesToCategories(services);
      pf.setString("categories", jsonEncode(encodeCategories(categories)));
    } else {
      categories = decodeCategories(jsonDecode(categoriesJson));
    }

    if (orders.isEmpty) {
      orders = await getOrders(authToken);
      orders.sort((a, b) => b.id!.compareTo(a.id!));
    }
    return Future.value("Ok");
  }
}
