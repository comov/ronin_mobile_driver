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
  final int? id;

  // todo: change to DateTime object
  final String? createdAt;

  // todo: change to DateTime object
  final String? modifiedAt;
  final int? status;
  final int? customerId;
  final int? carId;
  final int? driverId;
  final int? managerId;

  // todo: change to Entity
  final List<dynamic>? services;

  const Order({
    this.id,
    this.createdAt,
    this.modifiedAt,
    this.status,
    this.customerId,
    this.carId,
    this.driverId,
    this.managerId,
    this.services,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"],
      createdAt: json["created_at"],
      modifiedAt: json["modified_at"],
      status: json["status"],
      customerId: json["customer_id"],
      carId: json["car_id"],
      driverId: json["driver_id"],
      managerId: json["manager_id"],
      services: json["services"],
    );
  }
}
