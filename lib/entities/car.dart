class Car {
  int id;
  String brand;
  String model;
  String plateNumber;
  String? vin;
  int year;
  String createdAt;
  String modifiedAt;

  Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.plateNumber,
    this.vin,
    required this.year,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json["id"],
      brand: json["brand"],
      model: json["model"],
      plateNumber: json["plate_number"],
      vin: json["vin"],
      year: json["year"],
      createdAt: json["created_at"],
      modifiedAt: json["modified_at"],
    );
  }

  factory Car.empty() {
    return Car(
        id: 0,
        brand: "",
        model: "",
        plateNumber: "",
        year: 0,
        createdAt: "",
        modifiedAt: "");
  }

  String displayName() {
    return "$brand $model ($plateNumber)";
  }
}
