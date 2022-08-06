class Employee {
  final String? firstName;
  final String? lastName;
  final String? email;

  const Employee({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
    );
  }

  factory Employee.empty() {
    return const Employee(
      firstName: "",
      lastName: "",
      email: "",
    );
  }
}
