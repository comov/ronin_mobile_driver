import 'package:car_helper/entities/category.dart';
import 'package:flutter/material.dart';

mixin MainState {
  List<Category> categories = [];

  Widget renderMain(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Главная"),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 34,
        ),
      ),
      body: ListView(
        children: [
          Text("Какие-то блоки и ещё что-то"),
        ],
      ),
    );
  }
}
