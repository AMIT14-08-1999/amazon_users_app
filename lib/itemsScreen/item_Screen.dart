import 'package:amazon/itemsScreen/item_ui_design.dart';
import 'package:amazon/models/brands.dart';
import 'package:amazon/models/items.dart';
import 'package:amazon/widgets/text_delegate_header_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ItemsScreen extends StatefulWidget {
  Brands? model;
  ItemsScreen({Key? key, this.model}) : super(key: key);

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
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
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextDelegateHeaderWidget(
              title: "${widget.model!.brandTitle}'s items",
            ),
          ),
          StreamBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  itemBuilder: (context, index) {
                    Items itemsModel = Items.fromJson(
                      snapshot.data.docs[index].data() as Map<String, dynamic>,
                    );
                    return ItemsUiDesignWidget(
                      model: itemsModel,
                    );
                  },
                  itemCount: snapshot.data.docs.length,
                  staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text("No Items exists"),
                  ),
                );
              }
            },
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(widget.model!.sellerUID.toString())
                .collection("brands")
                .doc(widget.model!.brandID)
                .collection("items")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
          )
        ],
      ),
    );
  }
}
