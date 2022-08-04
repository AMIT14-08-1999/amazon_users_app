import 'dart:convert';

import 'package:amazon/RatingsScreen/rate_seller_screen.dart';
import 'package:amazon/global/global.dart';
import 'package:amazon/models/address.dart';
import 'package:amazon/splashScreen/my_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AddressDesign extends StatelessWidget {
  Address? model;
  String? orderStatus;
  String? orderId;
  String? sellerId;
  String? orderByUser;
  AddressDesign({
    Key? key,
    this.model,
    this.orderByUser,
    this.orderId,
    this.orderStatus,
    this.sellerId,
  }) : super(key: key);
  sendNotificationToUser(sellerUID, userOrderId) async {
    String sellerDeviceToken = "";
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerUID)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["sellerDeviceToken"] != null) {
        sellerDeviceToken = snapshot.data()!["sellerDeviceToken"].toString();
      }
    });
    notificationFormat(
      sellerDeviceToken,
      orderId,
      sharedPreferences!.getString("name"),
    );
  }

  notificationFormat(sellerDeviceToken, getUserOrderId, userName) {
    Map<String, String> headerNotification = {
      'Content-Type': "application/json",
      "Authorization": fcmServerToken,
    };
    Map bodyNotification = {
      'body':
          "Dear user, Parcel (# $getUserOrderId) has Received successfully by user $userName. \nPlease Check Now.. ",
      'title': "Parcel Received by User..",
    };
    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "userOrderId": getUserOrderId,
    };
    Map officialFormat = {
      'notification': bodyNotification,
      "data": dataMap,
      'priority': "High",
      'to': sellerDeviceToken,
    };
    http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialFormat),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Shopping Details:-- ",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 6.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text(
                    "Name: ",
                    style: TextStyle(color: Colors.green),
                  ),
                  Text(
                    model!.name.toString(),
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 4),
                  SizedBox(height: 4),
                ],
              ),
              TableRow(
                children: [
                  const Text(
                    "Phone No: ",
                    style: TextStyle(color: Colors.green),
                  ),
                  Text(
                    model!.phoneNumber.toString(),
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.completeAddress.toString(),
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (orderStatus == "normal") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => MySplashScreen(),
                ),
              );
            } else if (orderStatus == "shifted") {
              FirebaseFirestore.instance
                  .collection("orders")
                  .doc(orderId)
                  .update({
                "status": "ended",
              }).whenComplete(() {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(orderByUser)
                    .collection("orders")
                    .doc(orderId)
                    .update({
                  "status": "ended",
                });
                sendNotificationToUser(sellerId, orderId);
                Fluttertoast.showToast(msg: "Confirmed Successfully");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => MySplashScreen(),
                  ),
                );
              });
            } else if (orderStatus == "ended") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => RateSellerScreen(
                    sellerId: sellerId,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => MySplashScreen(),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              color: Colors.grey,
              width: MediaQuery.of(context).size.width - 40,
              height: orderStatus == "ended"
                  ? 60
                  : MediaQuery.of(context).size.height * .10,
              child: Center(
                child: Text(
                  orderStatus == "ended"
                      ? "Do You Want To Rate This Seller?"
                      : orderStatus == "shifted"
                          ? "Parcel Received, \nClick to confirm"
                          : orderStatus == "normal"
                              ? "Go Back"
                              : "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
