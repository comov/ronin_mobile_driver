import 'package:car_helper/entities/car.dart';
import 'package:car_helper/entities/driver.dart';
import 'package:car_helper/entities/service.dart';

enum OrderStatus {
  created,
  cancelled,
  pending,
  accepted,
  acceptedCar,
  onTrack,
  onCustomer,
  completed,
}

Map<int, String> orderStatusMap = {
  // Клиент создал заказ
  OrderStatus.cancelled.index: "Отменен",
  // Заказ отменен
  OrderStatus.pending.index: "В обработке",
  // Менеджер принял заказ и назначает водителя
  OrderStatus.accepted.index: "Принят",
  // Заказ назначен на водителя и водитель выполняет заказ
  OrderStatus.acceptedCar.index: "Машина у водителя",
  // Водитель принял машину у клиента
  OrderStatus.onTrack.index: "На выполнении",
  // Заказ на выполнении услуги (Сервиса)
  OrderStatus.onCustomer.index: "Машина у клиента",
  // Клиент забрал машину
  OrderStatus.completed.index: "Клиент оценил выполнение",
  // Клиент оценил выполнение заказа
  OrderStatus.created.index: "Создан",
};

String getOrderStatusText(int status) {
  return orderStatusMap[status]!;
}

class Order {
  final int id;
  final int status;
  final Car car;
  final Driver driver;
  final int managerId;
  final String createdAt;
  final String modifiedAt;

  final List<Service> services;

  const Order({
    required this.id,
    required this.status,
    required this.car,
    required this.driver,
    required this.managerId,
    required this.services,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final services = <Service>[];
    for (final item in json["services"]) {
      services.add(Service(id: item["id"], title: item["title"]));
    }
    return Order(
      id: json["id"],
      status: json["status"],
      car: json["car"] == null ? Car.empty() : Car.fromJson(json["car"]),
      driver: json["driver"] == null
          ? Driver.empty()
          : Driver.fromJson(json["driver"]),
      managerId: json["manager_id"] ?? 0,
      createdAt: json["created_at"],
      modifiedAt: json["modified_at"],
      services: services,
    );
  }
}
