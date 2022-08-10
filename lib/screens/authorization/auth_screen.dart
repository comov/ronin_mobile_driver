import 'dart:async';

import 'package:car_helper/resources/auth.dart';
import 'package:car_helper/resources/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  var otpCode = "";
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    loadFromStorage();

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Text("На ваш номер телефона должен прийти код подтверждения"),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  onChanged: (text) => {otpCode = text},
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Код подтверджения из СМС",
                    hintText: "0000",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Код подтверджения не может быть пустым";
                    }

                    if (value.length != 4) {
                      return "Код подтверджения должен быть из 4-х цифр";
                    }

                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      authCallBack().then((value) {
                        if (value == "Ok") {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            "/index",
                            (route) => false,
                          );
                        }
                      }
                      );
                    }
                  },
                  child: const Text("Отправить"),
                ),
                // TextButton(
                //   onPressed: enableResend ? _resendCode : null,
                //   child: Text(duration.inSeconds == 0
                //       ? "Отправить код еще раз"
                //       : "Отправить код еще раз через ${duration.inSeconds} секунд"),
                // ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future<String> loadFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    phoneNumber = pf.getString("phone_number") ?? "";
    return Future.value("Ok");
  }

  Future<String> saveAuthData(String token, String refreshKey) async {
    final pf = await SharedPreferences.getInstance();
    pf.setString("auth_token", token);
    pf.setString("refresh_key", refreshKey);
    return Future.value("Ok");
  }

  void singInCallBack() async {
    final response = await sigIn(phoneNumber);
    switch (response.statusCode) {
      case 200:
        {
          break;
        }
      default:
        {
          debugPrint("Ошибка при авторизации: ${response.statusCode}");
          debugPrint("response.error!.error=${response.error!.error}");
          debugPrint("response.error!.message=${response.error!.message}");
          break;
        }
    }
  }

  Future<String> authCallBack() async {
    final response = await auth(phoneNumber, otpCode);
    switch (response.statusCode) {
      case 200:
        {
          saveAuthData(response.auth!.token, response.auth!.refreshKey);
          break;
        }
      default:
        {
          debugPrint("Ошибка при авторизации: ${response.statusCode}");
          debugPrint("response.error!.error=${response.error!.error}");
          debugPrint("response.error!.message=${response.error!.message}");
          break;
        }
    }
    return Future.value("Ok");
  }
}
