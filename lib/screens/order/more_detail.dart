import 'package:car_helper/entities/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoreOrderDetailArgs {
  final Order order;

  MoreOrderDetailArgs({required this.order});
}

class MoreOrderDetail extends StatefulWidget {
  const MoreOrderDetail({Key? key}) : super(key: key);

  @override
  State<MoreOrderDetail> createState() => _MoreOrderDetailState();
}

class _MoreOrderDetailState extends State<MoreOrderDetail> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as MoreOrderDetailArgs;
    final order = args.order;
    var before = order.photos.where((element) => element?.kind == 0);
    var after = order.photos.where((element) => element?.kind == 1);

    final DateFormat formatter = DateFormat("d MMMM yyyy, HH:mm");

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
            Text("Статус: ${order.status}"),
            Text("Ваш комментарий: ${order.comment}"),
            const Divider(),
            Text("Адрес откуда забрать авто: ${order.pickUpAddress}"),
            order.pickUpTime != null
                ? Text(
                    "Время выполнения заявки: ${formatter.format(order.pickUpTime!.toLocal())} ")
                : const Text("Время выполнения заявки:"),
            const Divider(),
            Text(
                "ФИО Вашего менеджера: ${order.employee?.lastName} ${order.employee?.firstName}"),
            const Divider(),
            const Text("Ваше авто:"),
            Text("Марка: ${order.car?.brand}"),
            Text("Модель: ${order.car?.model}"),
            Text("ГОС. Номер авто: ${order.car?.plateNumber}"),
            Text(
                "ФИО водителя: ${order.driver?.lastName} ${order.driver?.firstName}"),
            Text("Номер телефона водителя: ${order.driver?.phone} "),
            const Divider(),
            const Text("Фотографии до:"),
            Column(
              children: [
                for (var image in before)
                  if (image != null) Image.network(image.imageUrl)
              ],
            ),
            const Text("Фотографии после:"),
            Column(
              children: [
                for (var image in after)
                  if (image != null) Image.network(image.imageUrl)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
