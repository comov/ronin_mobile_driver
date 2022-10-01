// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:car_helper_driver/entities/car.dart';
import 'package:car_helper_driver/resources/api_user_profile.dart';
import 'package:car_helper_driver/screens/order/detail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateCarArgs {
  Car editCar;
  final int orderId;

  UpdateCarArgs({required this.editCar, required this.orderId});
}

class UpdateCar extends StatefulWidget {
  const UpdateCar({Key? key}) : super(key: key);

  @override
  State<UpdateCar> createState() => _UpdateCarState();
}

class _UpdateCarState extends State<UpdateCar> {
  String authToken = "";
  List<Car> carList = [];

  String brand = "";
  String model = "";
  int? year;
  String vin = "";
  String plateNumber = "";
  DateTime selectedYear = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var args = ModalRoute.of(context)!.settings.arguments as UpdateCarArgs;
    var carItem = args.editCar;
    final orderId = args.orderId;

    FocusManager.instance.primaryFocus?.unfocus();

    var _selectedYear = DateTime(
        carItem.year,
        selectedYear.month,
        selectedYear.day,
        selectedYear.hour,
        selectedYear.minute,
        selectedYear.second,
        selectedYear.millisecond,
        selectedYear.microsecond);

    return FutureBuilder<String>(
      future: loadFromStorage(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Редактирование авто"),
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flex(direction: Axis.horizontal, children: [
                    Expanded(
                        child: Column(
                      children: [
                        TextFormField(
                          onChanged: (text) => {carItem.brand = text},
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
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

                            if (value.length >= 21) {
                              return "Поле не может быть больше 20 символов";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          onChanged: (text) => {carItem.model = text},
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
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
                            if (value == null || value.isEmpty) {
                              return "Поле не может быть пустым";
                            }

                            if (value.length >= 23) {
                              return "Поле не может быть больше 22 символов";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          onChanged: (text) => {carItem.plateNumber = text},
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          initialValue: carItem.plateNumber,
                          toolbarOptions: const ToolbarOptions(
                            copy: true,
                            cut: true,
                            paste: false,
                            selectAll: false,
                          ),
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
                            if (value!.length >= 12) {
                              return "Поле не может быть больше 11 символов";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          onChanged: (text) => {carItem.vin = text},
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
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
                            if (value!.length >= 21) {
                              return "Поле не может быть больше 20 символов";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          // onChanged: (text) => {carItem.year = int.parse(text)},
                          // autofocus: true,
                          // keyboardType: TextInputType.number,
                          initialValue: carItem.year.toString(),
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Выберите год"),
                                    content: SizedBox(
                                      width: 300,
                                      height: 300,
                                      child: YearPicker(
                                        firstDate: DateTime(
                                            DateTime.now().year - 100, 1),
                                        lastDate:
                                            DateTime(DateTime.now().year, 1),
                                        // initialDate: _selectedYear,
                                        selectedDate: _selectedYear,
                                        onChanged: (_selectedYear) {
                                          setState(() {
                                            carItem.year = _selectedYear.year;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  );
                                });
                          },
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
                            if (value!.length >= 5) {
                              return "Поле не может быть больше 4 символов";
                            } else if (value.length < 4) {
                              return "Поле не может быть меньше 4 символов";
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
                        _updateCar(carItem, orderId).then((value) async {
                          if (value == 200) {
                            Navigator.pushNamed(
                              context,
                              "/order/detail",
                              arguments: OrderDetailArgs(orderId: orderId),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Ошибка'),
                                content: SizedBox(
                                  height: 80,
                                  child: Column(
                                    children: const [
                                      Text(
                                          "Произошла ошибка редактирования авто")
                                    ],
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Назад')),
                                ],
                              ),
                            );
                          }
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

  Future<int> _updateCar(carItem, orderId) async {
    final response = await updateCar(authToken, orderId, carItem.id, carItem.brand,
        carItem.model, carItem.year ?? 0, carItem.plateNumber, carItem.vin);
    switch (response.statusCode) {
      case 200:
        {
          debugPrint("Авто было отредактировано!");
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
