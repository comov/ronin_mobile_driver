import 'package:car_helper/entities/user.dart';
import 'package:flutter/material.dart';

class UserEditArs {
  final Profile? profile;

  UserEditArs({required this.profile});
}

class UserEdit extends StatefulWidget {
  const UserEdit({Key? key}) : super(key: key);

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserEditArs;
    final profile = args.profile;

    return Scaffold(
      appBar: AppBar(title: const Text("Создание заказа")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Card(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("lastName: ${profile?.phone}"),
                  Text("firstName: ${profile?.firstName}"),
                  Text("lastName: ${profile?.lastName}"),
                ]),
          )),
          Expanded(
              child: Card(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Сохранить"),
                ),
              ]))),
        ],
      ),
    );
  }

  Future<String> loadInitialData() async {
    return Future.value("Ok");
  }
}
