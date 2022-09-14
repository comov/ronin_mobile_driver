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
        children: [
          const Expanded(
            child: Text("Последние два активных заказа"),
          ),
          Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Card(
                        margin: EdgeInsets.all(8),
                        color: Colors.amber,
                        // alignment: Alignment.center,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("Мойка авто")),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      width: 150,

                      child: Card(
                        margin: EdgeInsets.all(8),
                        color: Colors.amber,

                        // alignment: Alignment.center,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("Вызов эвакуатора")),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Card(
                        margin: EdgeInsets.all(8),
                        color: Colors.amber,
                        // alignment: Alignment.center,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("Выездной ремонт",                             maxLines: 2,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Card(
                          margin: EdgeInsets.all(8),
                          color: Colors.amber,
                          // alignment: Alignment.center,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("Автоподбор"))),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
