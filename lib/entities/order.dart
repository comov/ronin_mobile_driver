import 'package:car_helper/entities/car.dart';
import 'package:car_helper/entities/driver.dart';
import 'package:car_helper/entities/service.dart';
import 'package:car_helper/entities/employee.dart';
import 'package:car_helper/entities/photos.dart';


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


class Order {
  final int id;
  final String? comment;
  final String status;
  final String? pickUpAddress;
  final String? pickUpTime;
  final DateTime createdAt;
  final String modifiedAt;
  final Car? car;
  final Driver? driver;
  final Employee? employee;
  final List<Service> services;
  final List<Photos>? photos;

  const Order({
    required this.id,
    required this.comment,
    required this.pickUpAddress,
    required this.pickUpTime,
    required this.status,
    required this.car,
    required this.driver,
    required this.employee,
    required this.services,
    required this.createdAt,
    required this.modifiedAt,
    required this.photos,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final services = <Service>[];
    for (final item in json["services"]) {
      services.add(Service(id: item["id"], title: item["title"]));
    }
    final photos = <Photos>[];
    for (final item in json["photos"]) {
      photos.add(Photos(kind: item["kind"], imageUrl: item["image_url"]));
    }

    return Order(
      id: json["id"],
      comment: json["comment"],
      status: json["status"],
      pickUpAddress: json["pick_up_address"],
      pickUpTime: json["pick_up_time"],
      createdAt: DateTime.parse(json["created_at"]),

      // createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      modifiedAt: json["modified_at"],
      car: json["car"] == null
          ? Car.empty()
          : Car.fromJson(json["car"]),
      driver: json["driver"] == null
          ? Driver.empty()
          : Driver.fromJson(json["driver"]),
      employee: json["employee"] == null
          ? Employee.empty()
          : Employee.fromJson(json["employee"]),
      services: services,
      photos: photos,
    );
  }
}
