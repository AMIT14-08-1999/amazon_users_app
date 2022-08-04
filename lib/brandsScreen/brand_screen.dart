import 'package:amazon/brandsScreen/brand_ui_design.dart';
import 'package:amazon/models/brands.dart';
import 'package:amazon/models/sellers.dart';
import 'package:amazon/widgets/my_drawer.dart';
import 'package:amazon/widgets/text_delegate_header_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BrandScreen extends StatefulWidget {
  Sellers? model;
  BrandScreen({Key? key, this.model}) : super(key: key);
  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: MyDrawer(),
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
          "Amazon Sellers App",
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
              title: "${widget.model!.name} -- Brands",
            ),
          ),
          StreamBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  itemBuilder: (context, index) {
                    Brands brandsModel = Brands.fromJson(
                      snapshot.data.docs[index].data() as Map<String, dynamic>,
                    );
                    return BrandsUiDesignWidget(
                      model: brandsModel,
                    );
                  },
                  itemCount: snapshot.data.docs.length,
                  staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text("No brands exists"),
                  ),
                );
              }
            },
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(widget.model!.uid.toString())
                .collection("brands")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
          )
        ],
      ),
    );
  }
}
