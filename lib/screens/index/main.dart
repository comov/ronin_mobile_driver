import 'package:flutter/material.dart';

mixin MainState {

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
        children: const [
          Expanded(
            child: Text("Последние два активных заказа"),
          ),

        ],
      ),
    );
  }
}
