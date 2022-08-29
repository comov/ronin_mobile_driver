
import 'package:car_helper/entities/car.dart';
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
  int initialState;

  HomeArgs({required this.initialState});
}

// ignore: must_be_immutable
class Index extends StatefulWidget {
  int selectedBottom;
   Index(this.selectedBottom, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<Index> createState() => _IndexState(selectedBottom);
}

class _IndexState extends State<Index>
    with MainState, SingleTickerProviderStateMixin {
  String authToken = "";
  String phoneNumber = "";
  String refreshKey = "";

  Profile? profile;
  List<Car> carList = [];

  int selectedBottom = 0;
  Map<int, List> widgetOptions = {};

  List<Service> selectedServices = [];
  late TabController _tabController;
  _IndexState(this.selectedBottom);


  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TexInput.hide');
    super.initState();

    widgetOptions = {
      0: ["Главная", renderMain],
      1: ["Услуги", renderOrders],
      2: ["Заказы", bottomOrders],
      3: ["Профиль", BottomProfile],
    };
    _tabController = TabController(length: widgetOptions.length, vsync: this);
    _tabController.index = selectedBottom;

  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          selectedBottom = _tabController.index;
        });
      }
    });

    // todo: need to implement
    // var args = ModalRoute.of(context)!.settings.arguments;
    // debugPrint("args $args");
    // if (args != null) {
    //   HomeArgs? homeArgs = args as HomeArgs;
    //   // _onItemTapped(homeArgs.initialState);
    //   // _selectedBottom = homeArgs.initialState;
    //   homeArgs = null;
    //   args = null;
    //   homeArgs?.initialState = 0;
    //
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
        return DefaultTabController(
          length: widgetOptions.length,
          child: Scaffold(
            // appBar: AppBar(
            //   title: Text(widgetOptions[_selectedBottom]![0]),
            // ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: <Widget>[
                renderMain(context),
                renderOrders(context),
                bottomOrders(context),
                BottomProfile(tabController: _tabController),
              ],
            ),

            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(
                  fontSize: 10,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 10,
                ),
                tabs: [
                  Tab(
                    icon: SvgPicture.asset(homeIcon,
                        color:
                            selectedBottom == 0 ? Colors.black : Colors.grey),
                    text: 'Главная',
                  ),
                  Tab(
                    icon: SvgPicture.asset(
                      servicesIcon,
                      color: selectedBottom == 1 ? Colors.black : Colors.grey,
                    ),
                    text: 'Новый заказ',
                  ),
                  Tab(
                    icon: SvgPicture.asset(ordersIcon,
                        color:
                            selectedBottom == 2 ? Colors.black : Colors.grey),
                    text: 'Заказы',
                  ),
                  Tab(
                    icon: SvgPicture.asset(profileIcon,
                        color:
                            selectedBottom == 3 ? Colors.black : Colors.grey),
                    text: 'Профиль',
                  ),
                ],
              ),
            ),
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
