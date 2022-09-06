import 'package:car_helper/entities/order.dart';
import 'package:car_helper/screens/order/more_detail.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailArgs {
  final Order order;

  OrderDetailArgs({required this.order});
}

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrderDetailArgs;
    final order = args.order;
    final DateFormat formatter = DateFormat("d MMMM yyyy, HH:mm");
    StepperType stepperType = StepperType.vertical;

    currentState() {
      int step = 0;
      switch(order.status) {
        case "Создан":
          {
            step = 0;
            break;
          }
        case "В обработке":
          {
            step = 1;
            break;
          }
        case "Принят":
          {
            step = 2;
            break;
          }
        case "Машина у водителя":
          {
            step = 3;
            break;
          }
        case "На выполнении":
          {
            step = 4;
            break;
          }
        case "Машина у клиента":
          {
            step = 5;
            break;
          }
        case "Клиент оценил выполнение":
          {
            step = 6;
            break;
          }

      }
      return step;
    }


    final List<Step> steps = <Step> [
      Step(
          title: const Text("Создан"),
          content: Column(
            children: const [
              Text("тут время когда перешло на этот статус")
            ],
          ),
          isActive: order.status == "Создан",
          state: order.status == "Создан"
              ? StepState.complete
              : StepState.disabled),
      Step(
          title: const Text("В обработке"),
          content: Column(
            children: const [
              Text("тут время когда перешло на этот статус")
            ],
          ),
          isActive: order.status == "В обработке",
          state: order.status == "В обработке"
              ? StepState.complete
              : StepState.disabled),
      Step(
          title: const Text("Принят"),
          content: Column(
            children: const [
              Text("тут время когда перешло на этот статус")
            ],
          ),
          isActive: order.status == "Принят",
          state: order.status == "Принят"
              ? StepState.complete
              : StepState.disabled
      ),
      Step(
          title: const Text("Машина у водителя"),
          content: Column(
            children: const [
              Text("тут время когда перешло на этот статус")
            ],
          ),
          isActive: order.status == "Машина у водителя",
          state: order.status == "Машина у водителя"
              ? StepState.complete
              : StepState.disabled
      ),
      Step(
          title: const Text("На выполнении"),
          content: Column(
            children: const [
              Text("тут время когда перешло на этот статус")
            ],
          ),
          isActive: order.status == "На выполнении",
          state: order.status == "На выполнении"
              ? StepState.complete
              : StepState.disabled
      ),
      Step(
          title: const Text("Машина у клиента"),
          content: Column(
            children: const [
              Text("тут время когда перешло на этот статус")
            ],
          ),
          isActive: order.status == "Машина у клиента",
          state: order.status == "Машина у клиента"
              ? StepState.complete
              : StepState.disabled
      ),
      Step(
          title: const Text("Клиент оценил выполнение"),
          content: Column(
            children: const [
              Text("тут время когда перешло на этот статус")
            ],
          ),
          isActive: order.status == "Клиент оценил выполнение",
          state: order.status == "Клиент оценил выполнение"
              ? StepState.complete
              : StepState.disabled
      )
    ];


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(3.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: order.car?.plateNumber != ""
                  ? Text("${order.car?.plateNumber}")
                  : const Text("Гос.номер"),
            ),
          ],
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("ID заявки: ${order.id}"),
            Text(
                "Заявка создана: ${formatter.format(order.createdAt.toLocal())}"),
            Text(
                "Заявка обновлена: ${formatter.format(order.modifiedAt.toLocal())}"),
            Text("Статус: ${order.status}"),
            const Divider(),
            ExpansionTileCard(
              borderRadius: BorderRadius.circular(16),
              shadowColor: const Color.fromRGBO(0, 0, 0, 0.5),
              title: const Text('Выбранные услуги'),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      for (var item in order.services)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(item.title)),
                      // const SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Stepper(
                type: stepperType,
                physics: const ScrollPhysics(),
                currentStep: currentState(),
                // onStepTapped: (step) => tapped(step),
                // onStepContinue: continued,
                // onStepCancel: cancel,
                controlsBuilder: (BuildContext context, ControlsDetails controls) {
                  return Row(
                    children: const [
                      // Container()
                    ],
                  );
                },
                steps: steps

            ),
            const Divider(),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/order/more_detail",
                      arguments: MoreOrderDetailArgs(order: order));
                },
                child: const Text("Подробнее")),

            const TextButton(onPressed: null, child: Text("Чат с водителем"))
          ],
        ),
      ),
    );
  }
}
