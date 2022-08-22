class Driver {
  // final int id;
  final String phone;
  final String firstName;
  final String lastName;
  final String createdAt;
  final String modifiedAt;

  const Driver({
    // required this.id,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      // id: json["id"],
      phone: json["phone"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      createdAt: json["created_at"],
      modifiedAt: json["modified_at"],
    );
  }

  factory Driver.empty() {
    return const Driver(
      // id: 0,
      phone: "",
      firstName: "",
      lastName: "",
      createdAt: "",
      modifiedAt: "",
    );
  }
}
