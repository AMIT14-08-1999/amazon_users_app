import 'package:amazon/functions/functions.dart';
import 'package:amazon/global/global.dart';
import 'package:amazon/mainScreens/sellers_ui_design_widget.dart';
import 'package:amazon/models/sellers.dart';
import 'package:amazon/push_notification/push_notification_system.dart';
import 'package:amazon/splashScreen/my_splash_screen.dart';
import 'package:amazon/widgets/my_drawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  restrictBlockUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snapshot) {
      if (snapshot.data()!["status"] != "approved") {
        showReusableSnackBar(context, "You are blocked byt admin ..");
        showReusableSnackBar(
            context, "Contact admin: 8420324760 or admin@gmail.com");
        FirebaseAuth.instance.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MySplashScreen()));
      } else {
        cartMethods.clearCart(context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.whenNotificationReceived(context);
    pushNotificationSystem.generateDeviceRecognitionToken();
    restrictBlockUser();
  }

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
          "welcome Amazon",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.9,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: itemsImageList.map((index) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            index,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("sellers").snapshots(),
            builder: (context, AsyncSnapshot dataSnapshot) {
              if (dataSnapshot.hasData) {
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    Sellers model = Sellers.fromJson(
                        dataSnapshot.data.docs[index].data()
                            as Map<String, dynamic>);
                    return SellerUIDesignWidget(
                      model: model,
                    );
                  },
                  itemCount: dataSnapshot.data.docs.length,
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text("No Data Exists."),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
