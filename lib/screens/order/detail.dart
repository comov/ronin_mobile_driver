import 'package:car_helper/entities/order.dart';
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
    var before = order.photos.where((element) => element?.kind == 0);
    var after = order.photos.where((element) => element?.kind == 1);


    final DateFormat formatter = DateFormat("d MMMM yyyy, HH:mm");



    return Scaffold(
      appBar: AppBar(
        title: const Text("Детали заказа"),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 34,
        ),
      ),
      body: ListView(
        children: [
          Text("ID заявки: ${order.id}"),
          Text("Заявка создана: ${formatter.format(order.createdAt.toLocal())}"),

          Text("Заявка обновлена: ${formatter.format(order.modifiedAt.toLocal())}"),
          Text("Статус: ${order.status}"),
          const Divider(),
          Text("Адрес откуда забрать авто: ${order.pickUpAddress}"),
          order.pickUpTime != null
              ? Text(
                  "Время выполнения заявки: ${formatter.format(order.pickUpTime!.toLocal())} ")
              : const Text("Время выполнения заявки:"),
          Text(
              "ФИО Вашего менеджера: ${order.employee?.lastName} ${order.employee?.firstName}"),
          Text("Ваш комментарий: ${order.comment}"),
          const Divider(),
          const Text("Ваше авто:"),
          Text("Марка: ${order.car?.brand}"),
          Text("Модель: ${order.car?.model}"),
          Text("ГОС. Номер авто: ${order.car?.plateNumber}"),
          Text(
              "ФИО водителя: ${order.driver?.lastName} ${order.driver?.firstName}"),
          Text("Номер телефона водителя: ${order.driver?.phone} "),
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
          const Text("Фотографии до:"),
          Column(
            children: [
              for (var image in before )
                if (image != null)
                Image.network(image.imageUrl)
            ],
          ),
          const Text("Фотографии после:"),

          Column(
            children: [
              for (var image in after )
                if (image != null)
                  Image.network(image.imageUrl)
            ],
          ),
        ],
      ),
    );
  }
}
