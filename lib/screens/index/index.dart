import 'package:car_helper/screens/index/main.dart';
import 'package:car_helper/screens/index/orders.dart';
import 'package:car_helper/screens/index/profile.dart';
import 'package:car_helper/screens/index/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  int selectedBottom = 0;
  Map<int, List> widgetOptions = {};

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
      3: ["Профиль", bottomProfile],
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

    return DefaultTabController(
      length: widgetOptions.length,
      child: Scaffold(
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: <Widget>[
            renderMain(context),
            renderOrders(context),
            bottomOrders(context),
             bottomProfile(context),
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
                    color: selectedBottom == 0 ? Colors.black : Colors.grey),
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
                    color: selectedBottom == 2 ? Colors.black : Colors.grey),
                text: 'Заказы',
              ),
              Tab(
                icon: SvgPicture.asset(profileIcon,
                    color: selectedBottom == 3 ? Colors.black : Colors.grey),
                text: 'Профиль',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
