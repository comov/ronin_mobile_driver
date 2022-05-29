class Car {
  final int id;
  final String brand;
  final String model;
  final String plateNumber;
  final String? vin;
  final String year;
  final String createdAt;
  final String modifiedAt;

  const Car({
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
    return const Car(
        id: 0,
        brand: "",
        model: "",
        plateNumber: "",
        year: "",
        createdAt: "",
        modifiedAt: "");
  }
}
