import 'package:car_helper/resources/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mixins.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with DebugMixin {
  var phoneNumber = "";

  Future<String> loadFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    phoneNumber = pf.getString("phone_number") ?? "";
    return Future.value("Ok");
  }

  savePhoneNumber(String value) async {
    final pf = await SharedPreferences.getInstance();
    pf.setString("phone_number", value);
  }

  @override
  Widget build(BuildContext context) {
    printStorage("SignInScreen");
    return FutureBuilder<String>(
        future: loadFromStorage(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: Text("Загрузка...")),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    const Text("Ошибка при загрузке приложения :("),
                    Text("${snapshot.error}"),
                  ],
                ),
              ),
            );
          }

          final formKey = GlobalKey<FormState>();
          return Scaffold(
              body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Для входа в приложение, требуется авторизация."),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (text) => {phoneNumber = text},
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Номер телефона",
                          hintText: "996",
                        ),
                        initialValue: phoneNumber,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Номер телефона не может быть пустым";
                          }
                          if (value.length != 12) {
                            return "Номерт телефона должен быть в международном формате";
                          }

                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            singInCallBack();
                          }
                        },
                        child: const Text("Зарегистрироваться"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
        });
  }

  void singInCallBack() {
    sigIn(phoneNumber).then((response) => {
          if (response.error != "")
            {debugPrint(response.message)}
          else
            {
              savePhoneNumber(phoneNumber),
              debugPrint("СМС отправилось!"),
              Navigator.pushNamed(context, "/auth"),
            }
        });
  }
}
