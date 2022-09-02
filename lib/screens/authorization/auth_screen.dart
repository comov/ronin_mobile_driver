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
                  "Введите OTP код",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: '.SF Pro Text'),
                ),

                TextFormField(
                  onChanged: (text) => {otpCode = text},
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Код подтверджения из СМС",
                    labelStyle: TextStyle(
                        fontFamily: '.SF Pro Text', color: Colors.black),
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
                const Spacer(),
                // TextButton(
                //   onPressed: enableResend ? _resendCode : null,
                //   child: Text(duration.inSeconds == 0
                //       ? "Отправить код еще раз"
                //       : "Отправить код еще раз через ${duration.inSeconds} секунд"),
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      authCallBack().then((value) {
                        if (value == 200) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            "/index",
                            (route) => false,
                          );
                        }
                      });
                    }
                  },
                  child: const Text("Продолжить"),
                ),

              ]),
        ),
      ),
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

  Future<int> authCallBack() async {
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
    return Future.value(response.statusCode);
  }
}
