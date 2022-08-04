import 'package:amazon/brandsScreen/brand_screen.dart';
import 'package:amazon/models/sellers.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class SellerUIDesignWidget extends StatefulWidget {
  Sellers? model;
  SellerUIDesignWidget({Key? key, this.model}) : super(key: key);
  @override
  State<SellerUIDesignWidget> createState() => _SellerUIDesignWidgetState();
}

class _SellerUIDesignWidgetState extends State<SellerUIDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => BrandScreen(
                      model: widget.model,
                    )));
      },
      child: Card(
        color: Colors.black54,
        elevation: 20,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    widget.model!.photoUrl.toString(),
                    height: 220,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  widget.model!.name.toString(),
                  style: const TextStyle(
                    color: Colors.pink,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SmoothStarRating(
                  rating: widget.model!.ratings == null
                      ? 0.0
                      : double.parse(widget.model!.ratings.toString()),
                  starCount: 5,
                  color: Colors.purpleAccent,
                  borderColor: Colors.pinkAccent,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
