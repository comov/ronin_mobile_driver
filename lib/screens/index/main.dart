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
      body: Column(
        children:  [
          const Expanded(child: Text("Последние два активных заказа"),
          ),


         Expanded(
           child: Container(
             height: 100,
             margin: const EdgeInsets.symmetric(vertical: 20),
             child: ListView(
               scrollDirection: Axis.horizontal,
                children:  const [
                  Text("Быстрый заказ на мойку"),
                  Text("Вызов эвакуатора"),
                  Text("Выездной ремонт на месте"),
                  Text("Автоподбор")
                ],
              ),
           ),
         )
        ],
      ),
    );
  }
}
