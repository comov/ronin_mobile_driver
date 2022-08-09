import 'package:car_helper/entities/service.dart';

class Category {
  final String title;
  final String image;
  final List<Service> services;

  const Category({
    required this.title,
    required this.image,
    required this.services,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final services = <Service>[];
    for (final item in json["services"]) {
      services.add(Service(id: item["id"], title: item["title"]));
    }
    return Category(
      title: json["title"],
      image: json["image"],
      services: services,
    );
  }

  Map<String, dynamic> toJson() {
    final servicesJson = <Map<String, dynamic>>[];
    for (final service in services) {
      servicesJson.add(service.toJson());
    }
    return {
      "title": title,
      "image": image,
      "services": servicesJson,
    };
  }
}

List<Map<String, dynamic>> encodeCategories(List<Category> categories) {
  List<Map<String, dynamic>> categoriesJson = [];
  for (final category in categories) {
    categoriesJson.add(category.toJson());
  }
  return categoriesJson;
}

List<Category> decodeCategories(List<dynamic> categoriesJson) {
  List<Category> categories = [];
  for (final item in categoriesJson) {
    final List<Service> services = [];
    for (final i in item["services"]) {
      services.add(Service(id: i["id"], title: i["title"]));
    }

    final category = Category(
      title: item["title"],
      image: item["image"],
      services: services,
    );
    categories.add(category);
  }
  return categories;
}
