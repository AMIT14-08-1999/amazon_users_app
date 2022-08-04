import 'package:amazon/addressScreen/address_design_widget.dart';
import 'package:amazon/addressScreen/save_new_Address.dart';
import 'package:amazon/assistantMethods/address_changer.dart';
import 'package:amazon/global/global.dart';
import 'package:amazon/models/address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  String? sellerUID;
  double? totalAmount;
  AddressScreen({Key? key, this.sellerUID, this.totalAmount}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
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
          "Amazon",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => SaveNewAddress(
                sellerUID: widget.sellerUID.toString(),
                totalAmount: widget.totalAmount!.toDouble(),
              ),
            ),
          );
        },
        label: const Text("Add new address"),
        icon: const Icon(Icons.add_location_alt_outlined),
      ),
      body: Column(
        children: [
          Consumer<AddressChanger>(builder: (context, address, c) {
            return Flexible(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(sharedPreferences!.getString("uid"))
                  .collection("userAddress")
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length > 0) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return AddressDesignWidget(
                          address: Address.fromJson(snapshot.data.docs[index]
                              .data() as Map<String, dynamic>),
                          index: address.count,
                          value: index,
                          addressID: snapshot.data.docs[index].id,
                          totalAmount: widget.totalAmount,
                          sellerID: widget.sellerUID,
                        );
                      },
                      itemCount: snapshot.data.docs.length,
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return const Center(
                    child: Text("No Data Exists"),
                  );
                }
              },
            ));
          })
        ],
      ),
    );
  }
}
