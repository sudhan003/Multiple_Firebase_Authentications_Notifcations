import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NotificationProvider extends ChangeNotifier {
  sendNotification(
      {required String token,
      required String title,
      required String body}) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    Map<String, dynamic> data;
    data = {
      "registration_ids": [token],
      "collapse_key": "type_a",
      "notification": {
        "title": title,
        "body": body,
      },
      'data': {
        "title": title,
        "body": body,
        "_id":'This is the payload'
      },
    };
    final response =
        await http.post(Uri.parse(postUrl), body: json.encode(data), headers: {
      'content-type': 'application/json',
      'Authorization':
          "Key=AAAAqIjt_EU:APA91bGwzoeDuwIuCCp0Uq8DtlXqmzmfheKrcAIXKWQk7n8uPHuk2Mib779p3wNfzYhYDWeGGq3vQFU9mYG-0Z3PkQ5nI4p-FwzjZH6TWlQ3eC_lay2nXIIQCTBMW4_9iWr-2_Wx1OVu"
    });
    print(response.body);
  }
}
