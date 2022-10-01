import 'dart:async';

import 'package:car_helper_driver/resources/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  String phoneNumber = "";
  String password = "";
  bool validatePhone = false;
  bool validatePassword = false;

  TextEditingController textEditingPhoneNumberController = TextEditingController();
  TextEditingController textEditingPasswordController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loadFromStorage();

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Text(
                  "Вход",
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      fontFamily: '.SF Pro Display'),
                ),
                const Text(
                  "Введите номер телефона и пароль",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: '.SF Pro Text'),
                ),
                TextFormField(
                  onChanged: (text) => {phoneNumber = text},
                  autofocus: true,
                  controller: textEditingPhoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    errorText: validatePhone ? 'Введён не верный  номер-телефона' : null,
                    // labelText: "Код подтверджения из СМС",
                    labelStyle: const TextStyle(
                        fontFamily: '.SF Pro Text', color: Colors.black),
                    hintText: "Номер телефона",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Номер телефона не может быть пустым";
                    }
                    //
                    // if (value.length != 4) {
                    //   return "Номер телефона  должен быть из 4-х цифр";
                    // }

                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    onChanged: (text) => {password = text},
                    autofocus: true,
                    controller: textEditingPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      errorText: validatePassword ? 'Введён не верный  пароль' : null,
                      // labelText: "Код подтверджения из СМС",
                      labelStyle: const TextStyle(
                          fontFamily: '.SF Pro Text', color: Colors.black),
                      hintText: "Пароль",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Пароль не может быть пустым";
                      }
                      //
                      // if (value.length != 4) {
                      //   return "Номер телефона  должен быть из 4-х цифр";
                      // }

                      return null;
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        authCallBack().then((value) {
                          if (value == 200) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              "/checkerPage",
                              (route) => false,
                            );
                          }
                          else if (value == 405) {
                            setState(() {
                              validatePhone = true;
                            });
                          }

                          else if (value == 406) {
                            setState(() {
                              validatePassword = true;
                            });
                          }
                            else {
                            setState(() {
                              // validatePhone = true;
                              // validatePassword = true;
                            });
                          }
                        });
                      }
                    },
                    child: const Text("Продолжить"),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Future<String> loadFromStorage() async {
    return Future.value("Ok");
  }

  Future<String> saveAuthData(String token, String refreshKey) async {
    final pf = await SharedPreferences.getInstance();
    pf.setString("auth_token", token);
    pf.setString("refresh_key", refreshKey);
    return Future.value("Ok");
  }

  Future<int> authCallBack() async {
    final response = await auth(phoneNumber, password);
    switch (response.statusCode) {
      case 200:
        {
          saveAuthData(response.auth!.token, response.auth!.refreshKey);
          break;
        }
      default:
        {
          if (response.error!.message == "can not get driver from DB: record not found") {
            return Future.value(405);
          }
          if (response.error!.message == "auth failed: invalid password") {
            return Future.value(406);
          }

          debugPrint("Ошибка при авторизации: ${response.statusCode}");
          debugPrint("response.error!.error=${response.error!.error}");
          debugPrint("response.error!.message=${response.error!.message}");
          break;
        }
    }
    return Future.value(response.statusCode);
  }
}
