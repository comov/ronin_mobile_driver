import 'package:car_helper/entities.dart';
import 'package:car_helper/resources/api_services.dart';
import 'package:car_helper/screens/mixins.dart';
import 'package:car_helper/screens/services_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> with DebugMixin, CategoriesMixin {
  List<Category> categories = [];

  @override
  Widget build(BuildContext context) {
    printStorage("HomeScreen");
    return FutureBuilder<String>(
      future: loadCategories(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: Text("Загрузка...")),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  const Text("Ошибка при загрузке приложения :("),
                  Text("${snapshot.error}"),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Все категории")),
          body: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/services_screen", arguments: ServiceScreenArguments(category: categories[index]));
                  },
                  child: Text(categories[index].title),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        );
      },
    );
  }

  Future<String> loadCategories() async {
    final pf = await SharedPreferences.getInstance();
    final authToken = pf.getString("auth_token") ?? "";

    final services = await getServices(authToken);
    categories = fromServicesToCategories(services);
    return Future.value("Ok");
  }
}
