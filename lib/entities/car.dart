class Car {
  final int id;
  final String brand;
  final String model;
  final String plateNumber;
  final String? vin;
  final int year;
  final String createdAt;
  final String modifiedAt;
   bool expanded;



   Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.plateNumber,
    this.vin,
    required this.year,
    required this.createdAt,
    required this.modifiedAt,
    this.expanded = false
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
    return  Car(
        id: 0,
        brand: "",
        model: "",
        plateNumber: "",
        year: 0,
        createdAt: "",
        modifiedAt: "");
  }
}
