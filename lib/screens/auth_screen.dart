import 'dart:async';

import 'package:car_helper/resources/auth.dart';
import 'package:car_helper/resources/signin.dart';
import 'package:car_helper/screens/mixins.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> with DebugMixin {
  var otpCode = "";
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    printStorage("AuthScreen");
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
                Text("OTP: $otpCode"),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      authCollBack();
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

  saveAuthData(String token, String refreshKey) async {
    final pf = await SharedPreferences.getInstance();
    pf.setString("auth_token", token);
    pf.setString("refresh_key", refreshKey);
  }

  void singInCallBack() {
    sigIn(phoneNumber).then((response) => {
          if (response.error != "") {debugPrint(response.message)}
        });
  }

  void authCollBack() {
    SharedPreferences.getInstance()
        .then((prefs) => {prefs.getString("phone_number")})
        .then((phoneNumber) => {
              auth(phoneNumber.first.toString(), otpCode).then((response) => {
                    if (response.error != "")
                      {debugPrint(response.message)}
                    else
                      {
                        saveAuthData(
                          response.token ?? "",
                          response.refreshKey ?? "",
                        ),
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil("/home", (route) => false)
                      }
                  })
            });
  }
}
