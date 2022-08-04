import 'package:amazon/global/global.dart';
import 'package:amazon/splashScreen/my_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class RateSellerScreen extends StatefulWidget {
  String? sellerId;
  RateSellerScreen({Key? key, this.sellerId}) : super(key: key);

  @override
  State<RateSellerScreen> createState() => _RateSellerScreenState();
}

class _RateSellerScreenState extends State<RateSellerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        backgroundColor: Colors.white60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 22),
              Text(
                "Rate This Seller..",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 22),
              Divider(
                height: 4,
                thickness: 4,
              ),
              const SizedBox(height: 22),
              SmoothStarRating(
                rating: countStarsRating,
                allowHalfRating: true,
                starCount: 5,
                color: Colors.deepOrange,
                borderColor: Colors.purple,
                size: 46,
                onRatingChanged: (valuesOfStarsChoosed) {
                  countStarsRating = valuesOfStarsChoosed;
                  if (countStarsRating == 1) {
                    setState(() {
                      titleStarsRating = "Very Bad";
                    });
                  }
                  if (countStarsRating == 2) {
                    setState(() {
                      titleStarsRating = "Bad";
                    });
                  }
                  if (countStarsRating == 3) {
                    setState(() {
                      titleStarsRating = "Good";
                    });
                  }
                  if (countStarsRating == 4) {
                    setState(() {
                      titleStarsRating = "Very Good";
                    });
                  }
                  if (countStarsRating == 5) {
                    setState(() {
                      titleStarsRating = "Excellent";
                    });
                  }
                },
              ),
              const SizedBox(height: 22),
              Text(
                titleStarsRating,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("sellers")
                      .doc(widget.sellerId)
                      .get()
                      .then((snap) {
                    if (snap.data()!["ratings"] == null) {
                      FirebaseFirestore.instance
                          .collection("sellers")
                          .doc(widget.sellerId)
                          .update({
                        "ratings": countStarsRating.toString(),
                      });
                    } else {
                      double pastRatings =
                          double.parse(snap.data()!["ratings"].toString());
                      double newRatings = (pastRatings + countStarsRating) / 2;
                      FirebaseFirestore.instance
                          .collection("sellers")
                          .doc(widget.sellerId)
                          .update({
                        "ratings": newRatings.toString(),
                      });
                    }
                    Fluttertoast.showToast(msg: "Rated Successfully");
                    setState(() {
                      countStarsRating = 0.0;
                      titleStarsRating = "";
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => MySplashScreen()),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(horizontal: 74),
                ),
                child: Text("Submit"),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
