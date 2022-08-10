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
      appBar: AppBar(
        title: const Text("Редактирование профиля"),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    title: const Text("Данные профиля"),
                    subtitle: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          // Text("Ваш номер телефона: ${profile?.phone}"),
                          TextField(
                            onChanged: (val) {
                              profile?.firstName = val;
                            },
                            decoration:  InputDecoration(
                              border: const UnderlineInputBorder(),
                              labelText: profile?.firstName,
                              hintText: "Введите имя",
                            ),
                          ),
                          TextField(
                            onChanged: (val) {
                              profile?.lastName = val;
                            },
                            decoration:  InputDecoration(
                              border: const UnderlineInputBorder(),
                              labelText: profile?.lastName,
                              hintText: "Введите фамилию",
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: const Text("Добавить новое авто"),
                  subtitle: Column(
                    children: const <Widget>[
                      TextButton(onPressed: null, child: Text("Добавить Авто")),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: const Text("Удаление профиля"),
                  subtitle: Column(
                    children: const <Widget>[
                      TextButton(
                          onPressed: null, child: Text("Удаление профиля")),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Сохранить"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> loadInitialData() async {
    return Future.value("Ok");
  }
}

