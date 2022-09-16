class Profile {
  String phone;
  String firstName;
  String lastName;
  String createdAt;
  String modifiedAt;

  Profile({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      phone: json["phone"],
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      createdAt: json["created_at"],
      modifiedAt: json["modified_at"],
    );
  }
}
