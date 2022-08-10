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
    final formKey = GlobalKey<FormState>();
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
        child: Form(
          key: formKey,
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
                            TextFormField(
                              onChanged: (text) => {profile?.firstName = text},
                              autofocus: true,
                              keyboardType: TextInputType.text,
                              initialValue: profile?.firstName,
                              decoration: InputDecoration(
                                labelText: "Ваше имя",
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.length >= 12) {
                                  return "Поле может быть больше 12 символов";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              onChanged: (text) => {profile?.lastName = text},
                              autofocus: true,
                              keyboardType: TextInputType.text,
                              initialValue: profile?.lastName,
                              decoration: InputDecoration(
                                labelText: "Ваша фамилия",
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.length >= 12) {
                                  return "Поле может быть больше 12 символов";
                                }
                                return null;
                              },
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
                      children: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "/user/create_car",
                              );
                            },
                            child: const Text("Добавить Авто")),
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {}
                  },
                  child: const Text("Сохранить"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> loadInitialData() async {
    return Future.value("Ok");
  }
}
