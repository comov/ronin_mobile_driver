import 'package:car_helper/entities/user.dart';
import 'package:car_helper/resources/api_user_profile.dart';
import 'package:car_helper/screens/index/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserEditArs {
  final Profile? profile;

  UserEditArs({
    required this.profile,
  });
}

class UserEdit extends StatefulWidget {
  const UserEdit({Key? key}) : super(key: key);

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  String authToken = "";

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final args = ModalRoute.of(context)!.settings.arguments as UserEditArs;
    final profile = args.profile;

    return FutureBuilder<String>(
      future: loadFromStorage(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                                  onChanged: (text) =>
                                      {profile?.firstName = text},
                                  autofocus: true,
                                  keyboardType: TextInputType.text,
                                  initialValue: profile?.firstName,
                                  decoration: InputDecoration(
                                    labelText: "Имя",
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
                                  onChanged: (text) =>
                                      {profile?.lastName = text},
                                  autofocus: true,
                                  keyboardType: TextInputType.text,
                                  initialValue: profile?.lastName,
                                  decoration: InputDecoration(
                                    labelText: "Фамилия",
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
                        title: const Text("Удаление профиля"),
                        subtitle: Column(
                          children: <Widget>[
                            TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      contentPadding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 8),
                                      title: const Text('Удаление профиля',
                                          style: TextStyle(
                                              fontFamily: '.SF Pro Display')),
                                      content: const ListTile(
                                        title: Text(
                                          'Вы уверены?',
                                          style: TextStyle(
                                              // fontWeight: FontWeight.bold,
                                              fontFamily: '.SF Pro Display'),
                                        ),
                                        subtitle: Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child: Text(
                                              "Профиль будет полностью удален без возможности восстановить",
                                              style: TextStyle(
                                                  fontFamily: '.SF Pro Text')),
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.black, backgroundColor: Colors.grey[300]
                                          ),
                                          child: const Text('Отмена'),

                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              _deleteProfile().then((response) {
                                                if (response == 200) {
                                                  delFromStorage();
                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                    "/signin",
                                                    (route) => false,
                                                  );
                                                }
                                              });
                                            }, style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white, backgroundColor: Colors.red
                                        ),
                                            child: const Text(
                                              'Удалить',
                                            )),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Удаление профиля",
                                  style: TextStyle(color: Colors.red),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _editProfile(profile).then((response) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Index(3)),
                                (Route<dynamic> route) => false);
                          });
                        }
                      },
                      child: const Text("Сохранить"),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String> loadFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    authToken = pf.getString("auth_token") ?? "";

    return Future.value("Ok");
  }

  Future<int> _editProfile(profile) async {
    final response =
        await editProfile(authToken, profile.firstName, profile.lastName);
    switch (response.statusCode) {
      case 200:
        {
          final profile = response.profile;
          debugPrint("Профиль был отредактирован! Card.id: $profile");
          break;
        }
      default:
        {
          debugPrint(
              "Ошибка при редактировании профиля: ${response.statusCode}");
          debugPrint("response.error!.error=${response.error!.error}");
          debugPrint("response.error!.message=${response.error!.message}");
          break;
        }
    }

    return Future.value(response.statusCode);
  }

  Future<int> _deleteProfile() async {
    final response = await deleteProfile(authToken);
    switch (response.statusCode) {
      case 200:
        {
          final profile = response.profile;
          debugPrint("Профиль был отредактирован! Card.id: $profile");
          break;
        }
      default:
        {
          debugPrint(
              "Ошибка при редактировании профиля: ${response.statusCode}");
          debugPrint("response.error!.error=${response.error!.error}");
          debugPrint("response.error!.message=${response.error!.message}");
          break;
        }
    }

    return Future.value(response.statusCode);
  }

  void delFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    pf.remove("auth_token");
    pf.remove("refresh_key");
  }
}
