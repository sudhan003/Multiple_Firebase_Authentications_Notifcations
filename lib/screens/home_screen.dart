import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fireservices/provider/auth_provider.dart';
import 'package:fireservices/provider/notification_provider.dart';
import 'package:fireservices/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../local_notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // below function is used to change the state from "email not verified" to "verified"
  // @override
  // void didChangeDependencies() {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   authProvider.updateEmailVerificationState();
  //   super.didChangeDependencies();
  // }
@override
void initState() {
  //on init terminated state to open the app
  FirebaseMessaging.instance.getInitialMessage().then((value) => {
    if(value!=null){
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SecondScreen(message: value)))
    }
  });
  
  //init Foreground
  FirebaseMessaging.onMessage.listen((event) {
    LocalNotificationService.init();
    LocalNotificationService.displayNotification(event);
  });

  //init Background
  FirebaseMessaging.onMessageOpenedApp.listen((event) {});
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final fcmProvider = Provider.of<NotificationProvider>(context);
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                  onPressed: () {
                    model.logOut();
                  },
                  icon: const Icon(Icons.logout))
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            builder: (context, snapshot)
      {
        if (snapshot.hasData){
          return ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    fcmProvider.sendNotification(
                        token: snapshot.data!.docs[index]['token'],
                        title: snapshot.data!.docs[index]['user_name'],
                        body: "Hi, this my first notification in my life");
                  },
                  title: Text(snapshot.data!.docs[index]['user_name']),
                ),
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
      }else{
              return const Center( child: CircularProgressIndicator(),);
      }
            },
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
          )
          //     body:Center(
          // child: model.emailverified ?? false
          // ? const Text("Email verified",
          //     style: TextStyle(fontSize: 30, color: Colors.grey))
          //     : const Text("Email not verified",
          // style: TextStyle(fontSize: 30, color: Colors.grey))
          // // ],
          // ),
          );
    });
  }
}
