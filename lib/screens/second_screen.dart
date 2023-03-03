import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final RemoteMessage message;
  const SecondScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Details"),backgroundColor: Colors.black,),
        body: Column(children: [
      Text(message.data.toString()),
      Text(message.notification!.toMap().toString()),
    ]));
  }
}
