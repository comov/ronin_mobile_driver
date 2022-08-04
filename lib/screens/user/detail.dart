import 'package:car_helper/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailArs {
  final Profile profile;

  UserDetailArs({required this.profile});
}

class UserDetail extends StatefulWidget {
  const UserDetail({Key? key}) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  String authToken = "";
  String phoneNumber = "";
  String refreshKey = "";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserDetailArs;
    final profile = args.profile;

    return Scaffold(
      appBar: AppBar(title: const Text("Создание заказа")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("id: ${profile.id}"),
          Text("phone: ${profile.phone}"),
          Text("firstName: ${profile.firstName}"),
          Text("lastName: ${profile.lastName}"),
          Text("createdAt: ${profile.createdAt}"),
          Text("modifiedAt: ${profile.modifiedAt}"),

          // todo: Need to delete phoneNumber, authToken, refreshKey from this page
          Text("phoneNumber: $phoneNumber"),
          Text("authToken: $authToken"),
          Text("refreshKey: $refreshKey"),
          ElevatedButton(
            onPressed: () {
              delFromStorage();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/signin", (route) => false);
            },
            child: const Text("Выйти"),
          ),
        ],
      ),
    );
  }

  Future<String> loadInitialData() async {
    final pf = await SharedPreferences.getInstance();
    authToken = pf.getString("auth_token") ?? "";
    phoneNumber = pf.getString("phone_number") ?? "";
    refreshKey = pf.getString("refresh_key") ?? "";
    return Future.value("Ok");
  }

  void delFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    pf.remove("auth_token");
    pf.remove("refresh_key");
  }
}
