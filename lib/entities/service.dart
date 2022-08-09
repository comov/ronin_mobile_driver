class Service {
  final int id;
  final String title;
  final String description;

  const Service({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json["id"],
      title: json["title"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
    };
  }

  @override
  String toString() {
    return "$title (#$id)";
  }
}
