import 'package:car_helper/entities.dart';
import 'package:flutter/material.dart';

import 'mixins.dart';

class ServiceScreenArguments {
  final Category category;

  ServiceScreenArguments({required this.category});
}

class ServicesList extends StatefulWidget {
  const ServicesList({Key? key}) : super(key: key);

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList>
    with DebugMixin, CategoriesMixin {
  List<Category> categories = [];

  @override
  Widget build(BuildContext context) {
    printStorage("HomeScreen");
    final args = ModalRoute.of(context)!.settings.arguments as ServiceScreenArguments;
    return Scaffold(
      appBar: AppBar(title: Text(args.category.title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: args.category.services!.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                debugPrint("Pushed: ${args.category.services![index].title}");
              },
              child: Text(args.category.services![index].title),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
        const Divider(),
      ),
    );
  }
}
