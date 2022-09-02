import 'package:car_helper/resources/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var phoneNumber = "";

  var phoneFormatter = MaskTextInputFormatter(
      mask: '+### (###) ##-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  Future<String> loadFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    phoneNumber = pf.getString("phone_number") ?? "";
    return Future.value("Ok");
  }

  savePhoneNumber(String value) async {
    final pf = await SharedPreferences.getInstance();
    pf.setString("phone_number", value);
  }

  final String separator = '';

  @override
  Widget build(BuildContext context) {
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
              body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.center,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Вход",
                        style:
                            TextStyle(fontSize: 34, fontWeight: FontWeight.bold, fontFamily: '.SF Pro Display'),
                      ),
                    ),
                    const Text(
                      "Введите свой номер телефона",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: '.SF Pro Text'),
                    ),
                    TextFormField(
                      onChanged: (text) => {
                        phoneNumber = text,
                        phoneNumber = phoneFormatter.getUnmaskedText(),
                        debugPrint(phoneFormatter.getUnmaskedText()),
                      },
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [phoneFormatter],
                      decoration: const InputDecoration(
                        hintText: "996",
                      ),
                      // initialValue: phoneFormatter.getMask(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Номер телефона не может быть пустым";
                        } else if (value.isNotEmpty) {
                          bool mobileValid = RegExp(
                                  r'^\+996\s\([0-9]{3}\)\s[0-9]{2}-[0-9]{2}-[0-9]{2}')
                              .hasMatch(value);
                          return mobileValid
                              ? null
                              : "Введён некорректный формат номера телефона";
                        }

                        return null;
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top:8),
                      child: Text(
                        "Мы отправим вам sms с OTP кодом",
                        style: TextStyle(fontSize: 13, color: Colors.grey, fontFamily: '.SF Pro Text'),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          singInCallBack().then((value) {
                            if (value == 200) {
                              Navigator.pushNamed(context, "/auth");
                            }
                          });
                        }
                      },
                      child: const Text("Продолжить"),
                    ),
                  ],
                ),
              ),
            ),
          ));
        });
  }

  Future<int> singInCallBack() async {
    // debugPrint(phoneFormatter.getUnmaskedText());
    final response = await sigIn(phoneNumber);
    switch (response.statusCode) {
      case 200:
        {
          savePhoneNumber(phoneNumber);
          debugPrint("СМС отправилось!");
          break;
        }
      default:
        {
          debugPrint("Ошибка при отправки OPT: ${response.statusCode}");
          debugPrint("response.error!.error=${response.error!.error}");
          debugPrint("response.error!.message=${response.error!.message}");
          break;
        }
    }

    return Future.value(response.statusCode);
  }
}
