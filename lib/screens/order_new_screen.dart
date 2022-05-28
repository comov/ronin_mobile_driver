import 'package:car_helper/entities.dart';
import 'package:car_helper/resources/api_create_order.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mixins.dart';

class NewOrderArguments {
  final Category category;

  NewOrderArguments({required this.category});
}


class ListOfServices extends StatefulWidget {
  const ListOfServices({Key? key, required this.checkedServices}) : super(key: key);
  final Map<int, Map<String, dynamic>> checkedServices;

  @override
  State<ListOfServices> createState() => _ListOfServicesState(checkedServices: checkedServices);
}

class _ListOfServicesState extends State<ListOfServices> {
  final Map<int, Map<String, dynamic>> checkedServices;
  _ListOfServicesState({required this.checkedServices});

  @override
  Widget build(BuildContext context) {
    final servicesList = checkedServices.values.toList();
    return SizedBox(
      height: 500,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: servicesList.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(servicesList[index]["obj"].title),
                  value: servicesList[index]["checked"],
                  onChanged: (bool? value) {
                    setState(() {
                      servicesList[index]["checked"] = value!;
                    });
                  },
                );
              },
            ),

          ),
        ],
      ),
    );
  }
}

class OrderNew extends StatefulWidget {
  const OrderNew({Key? key}) : super(key: key);

  @override
  State<OrderNew> createState() => _OrderNewState();
}

class _OrderNewState extends State<OrderNew> with DebugMixin, CategoriesMixin {
  String authToken = "";

  final Map<int, Map<String, dynamic>> _checkedServices = {};

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    printStorage("HomeScreen");
    loadFromStorage();

    final args = ModalRoute.of(context)!.settings.arguments as NewOrderArguments;
    final services = args.category.services!;

    for (final i in services) {
      _checkedServices[i.id] = {"checked": false, "obj": i};
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Создание заказа")),
      body: Column(
        children: [
          const Text("Что входит в услугу"),
          const Text("Описание того, что входит в услугу"),
          ElevatedButton(
            onPressed: () {
              _showModalBottomSheet(context, _checkedServices);
            },
            child: const Text("Выбирете услугу"),
          ),
          ElevatedButton(
            onPressed: () {
              _createOrder(_checkedServices);
            },
            child: const Text("Создать заказ"),
          ),
        ],
      ),
    );
  }

  Future<String> loadFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    authToken = pf.getString("auth_token") ?? "";
    return Future.value("Ok");
  }

  void _showModalBottomSheet(BuildContext context, Map<int, Map<String, dynamic>> checkedServices) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return ListOfServices(checkedServices: checkedServices);
      },
    );
  }

  void _createOrder(Map<int, Map<String, dynamic>> checkedServices) async {
    final List<int> services = [];
    checkedServices.forEach((id, info) {
      if (info["checked"] == true) {
        services.add(id);
      }
    });

    final newOrderResponse = await createOrder(authToken, services);
    if (newOrderResponse.id != 0 && newOrderResponse.id != null) {
      debugPrint("Заказ был создан! Order: ${newOrderResponse.id}");
    } else {
      debugPrint("Что-то пошло не так: $newOrderResponse");
    }
  }
}
