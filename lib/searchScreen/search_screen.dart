import 'package:amazon/mainScreens/sellers_ui_design_widget.dart';
import 'package:amazon/models/sellers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SrarchScreen extends StatefulWidget {
  const SrarchScreen({Key? key}) : super(key: key);

  @override
  State<SrarchScreen> createState() => _SrarchScreenState();
}

class _SrarchScreenState extends State<SrarchScreen> {
  String sellerNameText = "";
  Future<QuerySnapshot>? storesDocumentsList;

  initializeSearchingStores(String textEnteredByUser) {
    storesDocumentsList = FirebaseFirestore.instance
        .collection("sellers")
        .where("name", isGreaterThanOrEqualTo: textEnteredByUser)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
            ),
          ),
        ),
        title: TextField(
          onChanged: (value) {
            setState(() {
              sellerNameText = value;
            });
            initializeSearchingStores(sellerNameText);
          },
          decoration: InputDecoration(
            hintText: "Search Seller Here .....",
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                initializeSearchingStores(sellerNameText);
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: storesDocumentsList,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                Sellers model = Sellers.fromJson(
                  snapshot.data.docs[index].data() as Map<String, dynamic>,
                );
                return SellerUIDesignWidget(
                  model: model,
                );
              },
            );
          } else {
            return Center(
              child: Text("No Record Found.."),
            );
          }
        },
      ),
    );
  }
}
