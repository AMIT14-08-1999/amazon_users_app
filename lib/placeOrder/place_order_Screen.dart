import 'dart:convert';

import 'package:amazon/global/global.dart';
import 'package:amazon/mainScreens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PlaceOrderScreen extends StatefulWidget {
  String? addressID;
  double? totalAmount;
  String? sellerUID;
  PlaceOrderScreen({Key? key, this.addressID, this.sellerUID, this.totalAmount})
      : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  orderDetails() {
    saveOrderDetailsForUser({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash On Delivery",
      "orderTime": orderId,
      "orderId": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "status": "normal"
    }).whenComplete(() {
      saveOrderDetailsForSeller({
        "addressID": widget.addressID,
        "totalAmount": widget.totalAmount,
        "orderBy": sharedPreferences!.getString("uid"),
        "productIDs": sharedPreferences!.getStringList("userCart"),
        "paymentDetails": "Cash On Delivery",
        "orderTime": orderId,
        "orderId": orderId,
        "sellerUID": widget.sellerUID,
        "isSuccess": true,
        "status": "normal"
      }).whenComplete(() {
        cartMethods.clearCart(context);
        sendNotificationToSeller(
          widget.sellerUID.toString(),
          orderId,
        );
        Fluttertoast.showToast(
            msg: "Congratulations,Order has been placed successfully..");
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => HomeScreen()));
        orderId = "";
      });
    });
  }

  saveOrderDetailsForUser(Map<String, dynamic> orderDetailsMap) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(orderDetailsMap);
  }

  saveOrderDetailsForSeller(Map<String, dynamic> orderDetailsMap) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(orderDetailsMap);
  }

  sendNotificationToSeller(sellerUID, userOrderId) async {
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
      userOrderId,
      sharedPreferences!.getString("name"),
    );
  }

  notificationFormat(sellerDeviceToken, orderId, userName) {
    Map<String, String> headerNotification = {
      'Content-Type': "application/json",
      "Authorization": fcmServerToken,
    };
    Map bodyNotification = {
      'body':
          "Dear seller, New Order (# $orderId) has placed succeddfully from user $userName. \nPlease Check Now",
      'title': "New Order",
    };
    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "userOrderId": orderId,
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/delivery.png"),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              orderDetails();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan,
            ),
            child: const Text("Place Order Now"),
          ),
        ],
      ),
    );
  }
}
