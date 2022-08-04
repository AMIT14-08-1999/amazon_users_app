import 'package:amazon/OrdersScreens/address_design_widget.dart';
import 'package:amazon/OrdersScreens/status_banner.dart';
import 'package:amazon/addressScreen/address_design_widget.dart';
import 'package:amazon/global/global.dart';
import 'package:amazon/models/address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {
  String? orderID;
  OrderDetailsScreen({Key? key, this.orderID}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String? orderStatus = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(sharedPreferences!.getString("uid"))
              .collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (context, AsyncSnapshot snapshot) {
            Map? dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data.data() as Map<String, dynamic>;
              orderStatus = dataMap["status"].toString();
              return Column(
                children: [
                  StatusBanner(
                    status: dataMap["isSuccess"],
                    orderStatus: orderStatus,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "₹ " + dataMap["totalAmount"].toString(),
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Order ID: " + dataMap["orderId"].toString(),
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Order At: " +
                            DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(dataMap["orderTime"]))),
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 4,
                    color: Colors.white,
                  ),
                  orderStatus == "ended"
                      ? Image.asset("images/delivered.png")
                      : Image.asset("images/state.png"),
                  const Divider(
                    thickness: 1,
                    color: Colors.pinkAccent,
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(sharedPreferences!.getString("uid"))
                        .collection("userAddress")
                        .doc(dataMap["addressID"])
                        .get(),
                    builder: (c, AsyncSnapshot snapShot) {
                      if (snapShot.hasData) {
                        return AddressDesign(
                          model: Address.fromJson(
                              snapShot.data.data() as Map<String, dynamic>),
                          orderStatus: orderStatus,
                          orderId: widget.orderID,
                          sellerId: dataMap!["sellerUID"],
                          orderByUser: dataMap["orderBy"],
                        );
                      } else {
                        return Center(
                          child: Text(
                            "No Data Exists",
                          ),
                        );
                      }
                    },
                  )
                ],
              );
            } else {
              return Center(
                child: Text("No Data Exists"),
              );
            }
          },
        ),
      ),
    );
  }
}
