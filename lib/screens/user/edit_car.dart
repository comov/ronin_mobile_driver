import 'dart:async';

import 'package:car_helper/entities/car.dart';
import 'package:car_helper/resources/api_user_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditCarArgs {
  Car editCar;

  EditCarArgs({required this.editCar});
}

class EditCar extends StatefulWidget {
  const EditCar({Key? key}) : super(key: key);

  @override
  State<EditCar> createState() => _EditCarState();
}

class _EditCarState extends State<EditCar> {
  String authToken = "";
  List<Car> carList = [];

  String brand = "";
  String model = "";
  int? year;
  String vin = "";
  String plateNumber = "";

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final args = ModalRoute.of(context)!.settings.arguments as EditCarArgs;

    var carItem = args.editCar;

    FocusManager.instance.primaryFocus?.unfocus();

    return FutureBuilder<String>(
      future: loadFromStorage(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Scaffold(
          appBar: AppBar(
              // title: const Text("Добавление авто"),
              // titleTextStyle: const TextStyle(
              //   color: Colors.black,
              //   fontWeight: FontWeight.bold,
              //   fontSize: 20,
              // ),
              ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Редактирование авто",
                    style: TextStyle(fontSize: 34),
                  ),
                  Flex(direction: Axis.horizontal, children: [
                    Expanded(
                        child: Column(
                      children: [
                        TextFormField(
                          onChanged: (text) => {carItem.brand = text},
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          initialValue: carItem.brand,
                          decoration: InputDecoration(
                            labelText: "Марка авто",
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
                            if (value == null || value.isEmpty) {
                              return "Поле не может быть пустым";
                            }

                            if (value.length >= 10) {
                              return "Поле может быть больше 10 символов";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          onChanged: (text) => {carItem.model = text},
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          initialValue: carItem.model,
                          decoration: InputDecoration(
                            labelText: "Модель авто",
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
                            if (value!.length >= 10) {
                              return "Поле может быть больше 10 символов";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          onChanged: (text) => {carItem.plateNumber = text},
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          initialValue: carItem.plateNumber,
                          decoration: InputDecoration(
                            labelText: "Гос. Номер авто",
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
                            if (value!.length >= 10) {
                              return "Поле может быть больше 10 символов";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          onChanged: (text) => {carItem.vin = text},
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          initialValue: carItem.vin,
                          decoration: InputDecoration(
                            labelText: "VIN номер авто",
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
                          onChanged: (text) => {carItem.year = int.parse(text)},
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          initialValue: carItem.year.toString(),
                          decoration: InputDecoration(
                            labelText: "Год авто",
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
                              if (value!.length >= 4) {
                                return "Поле может быть больше 4 символов";
                              }

                            return null;
                          },
                        ),
                      ],
                    )),
                  ]),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _editCar(carItem).then((response) {
                          // Navigator.of(context).pushNamedAndRemoveUntil(
                          //   "/user/edit",
                          //       (route) => false,
                          //   // arguments: HomeArgs(initialState: 2),
                          // );
                        });
                      }
                    },
                    child: const Text("Сохранить"),
                  ),
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

  Future<int> _editCar(carItem) async {
    final response = await editCar(authToken, carItem.id, carItem.brand,
        carItem.model, carItem.year ?? 0, carItem.vin, carItem.plateNumber);
    switch (response.statusCode) {
      case 200:
        {
          final car = response.cars;
          debugPrint("Авто было отредактировано! Card.id: $car");
          break;
        }
      case 403:
        {
          debugPrint("У Вас превышен лимит авто: ${response.statusCode}");
          break;
        }
      default:
        {
          debugPrint("Ошибка при редактировании Авто: ${response.statusCode}");
          debugPrint("response.error!.error=${response.error!.error}");
          debugPrint("response.error!.message=${response.error!.message}");
          break;
        }
    }

    return Future.value(response.statusCode);
  }
}
