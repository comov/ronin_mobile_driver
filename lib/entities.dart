class Service {
  final int id;
  final String title;

  const Service({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
    };
  }
}

class Category {
  final int id;
  final String title;
  List<Service>? services;

  Category({
    required this.id,
    required this.title,
    this.services,
  });

  Map<String, dynamic> toJson() {
    final servicesJson = [];
    for (final service in services!) {
      servicesJson.add(service.toJson());
    }
    return {
      "id": id,
      "title": title,
      "services": servicesJson,
    };
  }
}

class ServiceWithCategory {
  final int id;
  final String title;
  Category? category;

  ServiceWithCategory({
    required this.id,
    required this.title,
    this.category,
  });
}

List<ServiceWithCategory> listOfCategoriesFromJson(List<dynamic> jsonList) {
  List<ServiceWithCategory> services = [];
  for (var item in jsonList) {
    final service = ServiceWithCategory(
      id: item["id"],
      title: item["title"],
      category: Category(
        id: item["category"]["id"],
        title: item["category"]["title"],
      ),
    );
    services.add(service);
  }
  return services;
}

List<Category> fromServicesToCategories(List<ServiceWithCategory> services) {
  Map<int, Category> categoriesMap = {};
  for (ServiceWithCategory item in services) {
    var category = item.category!;
    if (categoriesMap.containsKey(category.id)) {
      category = categoriesMap[category.id]!;
    }
    category.services ??= [];
    final serviceItem = Service(id: item.id, title: item.title);
    category.services!.add(serviceItem);
    categoriesMap[category.id] = category;
  }
  return categoriesMap.values.toList();
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
      id: item["id"],
      title: item["title"],
      services: services,
    );
    categories.add(category);
  }
  return categories;
}
