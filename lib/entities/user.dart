class Profile {
  final int id;
  final String phone;
  final String firstName;
  final String lastName;
  final String createdAt;
  final String modifiedAt;

  const Profile({
    required this.id,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json["id"],
      phone: json["phone"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      createdAt: json["created_at"],
      modifiedAt: json["modified_at"],
    );
  }
}
