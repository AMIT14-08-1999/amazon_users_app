import 'package:amazon/functions/functions.dart';
import 'package:amazon/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future whenNotificationReceived(BuildContext context) async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        showNotificationWhenopenApp(
          remoteMessage.data["userOrderId"],
          context,
        );
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        showNotificationWhenopenApp(
          remoteMessage.data["userOrderId"],
          context,
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        showNotificationWhenopenApp(
          remoteMessage.data["userOrderId"],
          context,
        );
      }
    });
  }

  Future generateDeviceRecognitionToken() async {
    String? registrationDeviceToken = await messaging.getToken();

    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .update({
      "userDeviceToken": registrationDeviceToken,
    });

    messaging.subscribeToTopic("allSellers");
    messaging.subscribeToTopic("allUsers");
  }

  showNotificationWhenopenApp(userOrderId, context) {
    showReusableSnackBar(context,
        "Your Parcel (# $userOrderId) has been shifted successfully .");
  }
}
