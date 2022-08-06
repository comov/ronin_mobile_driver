import 'dart:convert';

import 'package:car_helper/entities/car.dart';
import 'package:car_helper/entities/category.dart';
import 'package:car_helper/entities/order.dart';
import 'package:car_helper/entities/user.dart';
import 'package:car_helper/resources/api_categories.dart';
import 'package:car_helper/resources/api_order_list.dart';
import 'package:car_helper/resources/api_user_profile.dart';
import 'package:car_helper/resources/refresh.dart';
import 'package:car_helper/screens/authorization/sign_in_screen.dart';
import 'package:car_helper/screens/order/create.dart';
import 'package:car_helper/screens/order/detail.dart';
import 'package:car_helper/screens/user/user_edit.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
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
  List<Car?> car = [];

  int _selectedBottom = 0;
  Map<int, List> widgetOptions = {};
  final Map<int, Map<String, dynamic>> _servicesMap = {};
  final DateFormat formatter = DateFormat("d MMMM yyyy, hh:mm");

  @override
  void initState() {
    super.initState();

    widgetOptions = {
      0: ["Главная", bottomCategories],
      1: ["Новый заказ", createOrder],
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
    const String homeIcon = "assets/images/tabbarhome.svg";
    const String servicesIcon = "assets/images/TabBarServices.svg";
    const String ordersIcon = "assets/images/TabBarOrders.svg";
    const String profileIcon = "assets/images/TabBarProfile.svg";

    // String orderDateTime = DateFormat.MMMMEEEEd().format()

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
          case "tokenExpired":
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

  Widget createOrder() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      // crossAxisSpacing: 16,
      padding: const EdgeInsets.all(20),

      children: List.generate(categories.length, (index) {
        return TextButton(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      width: double.infinity,
                      height: 100,
                      // padding: EdgeInsets.all(32),

                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          categories[index].title,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      )),

                  // style: Theme.of(context).textTheme.headline5,
                ]),
            onPressed: () async {
              _showModalBottomSheet(context, _servicesMap);
            });
      }),
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
              child: RichText(
                  text: TextSpan(children: <InlineSpan>[
                TextSpan(text: "${orders[index].id}"),
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                  ),
                ),
                TextSpan(text: formatter.format(orders[index].createdAt)),
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, left: 10),
                  ),
                ),
                TextSpan(text: orders[index].status)
              ]))),
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

          return ListView(
            children: <Widget>[
              Expanded(
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 5),
                        Text(
                          "Фамилия: ${profile!.lastName}",
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          "Имя: ${profile!.firstName}",
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Номер телефона: ${profile!.phone}",
                        ),
                        const SizedBox(height: 5),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "/user/user_edit",
                                arguments: UserEditArs(profile: profile),
                              );
                            },
                            child: Text("Редактировать профиль"))
                      ]),
                )),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  // padding: const EdgeInsets.all(1),
                  itemCount: car.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ExpansionTileCard(
                        title: Text(
                            '${car[index]?.brand}' " " '${car[index]?.model}'),
                        subtitle: Text('${car[index]?.plateNumber}'),
                        children: <Widget>[
                          const Divider(
                            thickness: 1.0,
                            height: 1.0,
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    const SizedBox(height: 5),
                                    Text("id:" '${car[index]?.id.toString()}'),
                                    Text("Марка авто:" '${car[index]?.brand}'),
                                    Text("Модель авто:" '${car[index]?.model}'),
                                    Text("Гос. Номер:"
                                        '${car[index]?.plateNumber}'),
                                    Text("VIN авто:" '${car[index]?.vin}'),
                                    Text("Год авто:"
                                        '${car[index]?.year.toString()}'),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),
              Expanded(
                child: Card(
                  child: Column(
                    children: <Widget>[
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
                  ),
                ),
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

  void _showModalBottomSheet(
    BuildContext context,
    Map<int, Map<String, dynamic>> servicesMap,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return ListOfServices(servicesMap: servicesMap);
      },
    );
  }

  Future<String> loadInitialData() async {
    final pf = await SharedPreferences.getInstance();
    //update categories

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
            final refreshResponse = await refreshToken(refreshKey);
            if (refreshResponse.statusCode == 200) {
              authToken = refreshResponse.auth!.token;
              refreshKey = refreshResponse.auth!.refreshKey;
              saveAuthData(authToken, refreshKey);
              break;
            } else {
              debugPrint(
                  "refreshResponse.statusCode: ${refreshResponse.statusCode}");
              debugPrint("refreshResponse.error: ${refreshResponse.error}");
              return Future.value("tokenExpired");
            }
          }
      }
    }

    if (car.isEmpty) {
      car = await getCustomerCars(authToken);
    } else {
      car = await getCustomerCars(authToken);

      // List<Map<String, dynamic>> _items = List.generate(
      //     car.length,
      //         (index) => {
      //       'id': index,
      //       'title': 'Item $index',
      //       'description':
      //       'This is the description of the item $index. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      //       'isExpanded': false
      //     });

    }

    final categoriesJson = pf.getString("categories") ?? "";
    if (categoriesJson == "" || categoriesJson == "[]") {
      final categoriesResponse = await getCategories(authToken);
      switch (categoriesResponse.statusCode) {
        case 200:
          {
            categories = categoriesResponse.categories;
          }
          break;
        case 401:
          {
            return Future.value("tokenExpired");
          }
      }

      pf.setString("categories", jsonEncode(encodeCategories(categories)));
    } else {
      final categoriesResponse = await getCategories(authToken);
      switch (categoriesResponse.statusCode) {
        case 200:
          {
            categories = categoriesResponse.categories;
          }
          break;
        case 401:
          {
            return Future.value("tokenExpired");
          }
      }
      pf.setString("categories", jsonEncode(encodeCategories(categories)));

      categories = decodeCategories(jsonDecode(categoriesJson));
    }

    //update ordersList
    orders = await getOrders(authToken);

    // if (orders.isEmpty) {
    //   orders = await getOrders(authToken);
    // } else {
    //   orders = await getOrders(authToken);
    // }
    return Future.value("Ok");
  }

  Future<String> saveAuthData(String token, String refreshKey) async {
    final pf = await SharedPreferences.getInstance();
    pf.setString("auth_token", token);
    pf.setString("refresh_key", refreshKey);
    return Future.value("Ok");
  }
}
