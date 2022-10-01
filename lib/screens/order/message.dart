// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:car_helper_driver/entities/customer.dart';
import 'package:car_helper_driver/entities/driver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Messages extends StatefulWidget {
  String orderId;
  Driver? driver;

  Messages({super.key, required this.orderId, required this.driver});

  @override
  // ignore: library_private_types_in_public_api
  _MessagesState createState() =>
      _MessagesState(orderId: orderId, driver: driver);
}

class _MessagesState extends State<Messages> {
  String orderId;
  Driver? driver;

  _MessagesState({required this.orderId, required this.driver});

  @override
  Widget build(BuildContext context) {
    String uid = "driver:${driver!.id}";
    Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
        .collection('rooms')
        .doc('order_$orderId')
        .collection("messages")
        .orderBy('timestamp')
        .snapshots();

    return StreamBuilder(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("something is wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          primary: true,
          itemBuilder: (_, index) {
            QueryDocumentSnapshot qs = snapshot.data!.docs[index];
            Timestamp t = qs['timestamp'];
            DateTime d = t.toDate();
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: uid == qs['uid']
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        qs['name'],
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              qs['text'],
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            "${d.hour}:${d.minute}",
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
