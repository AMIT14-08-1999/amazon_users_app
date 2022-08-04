import 'package:amazon/OrdersScreens/order_card.dart';
import 'package:amazon/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.pinkAccent,
              Colors.purpleAccent,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        title: const Text(
          "Parcel History",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("status", isEqualTo: "ended")
            .where("orderBy", isEqualTo: sharedPreferences!.getString("uid"))
            .orderBy("orderTime", descending: true)
            .snapshots(),
        builder: ((context, AsyncSnapshot dataSnapshot) {
          if (dataSnapshot.hasData) {
            return ListView.builder(
              itemCount: dataSnapshot.data.docs.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("items")
                      .where("itemID",
                          whereIn: cartMethods.separateOrderItemIDs(
                              (dataSnapshot.data.docs[index].data()
                                  as Map<String, dynamic>)["productIDs"]))
                      .where("sellerUID",
                          whereIn: (dataSnapshot.data.docs[index].data()
                              as Map<String, dynamic>)["uid"])
                      .orderBy("publishedDate", descending: true)
                      .get(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return OrderCard(
                        itemCount: snapshot.data.docs.length,
                        data: snapshot.data.docs,
                        orderId: dataSnapshot.data.docs[index].id,
                        seperateQuantityList:
                            cartMethods.separateOrderItemQuantity(
                          (dataSnapshot.data.docs[index].data()
                              as Map<String, dynamic>)["productIDs"],
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text("No Data Exists"),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text("No Data Exists"),
            );
          }
        }),
      ),
    );
  }
}
