class Service {
  final int id;
  final String title;

  const Service({
    required this.id,
    required this.title,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json["id"],
      title: json["title"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
    };
  }

  @override
  String toString() {
    return "$title (#$id)";
  }
}
