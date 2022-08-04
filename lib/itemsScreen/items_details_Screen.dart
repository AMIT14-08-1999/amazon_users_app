import 'package:amazon/global/global.dart';
import 'package:amazon/models/items.dart';
import 'package:amazon/widgets/appBar_cart_badge.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ItemsDetailsScreen extends StatefulWidget {
  Items? model;
  ItemsDetailsScreen({Key? key, this.model}) : super(key: key);

  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();
}

class _ItemsDetailsScreenState extends State<ItemsDetailsScreen> {
  int countLmit = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBarCartBadge(
        sellerUID: widget.model!.sellerUID.toString(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          int itemCounter = countLmit;
          List<String> itemsIDList = cartMethods.separateItemIDUserCartList();
          if (itemsIDList.contains(widget.model!.itemID)) {
            Fluttertoast.showToast(msg: "Item is already in cart");
          } else {
            cartMethods.addItemCart(
              widget.model!.itemID.toString(),
              itemCounter,
              context,
            );
          }
        },
        label: const Text(
          "Add To Cart",
        ),
        icon: const Icon(
          Icons.shopping_cart_checkout,
          color: Colors.black,
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.model!.thumbnailUrl.toString(),
                height: 220,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: CartStepperInt(
                    size: 50,
                    count: countLmit,
                    elevation: 0,
                    style: const CartStepperStyle(
                      deActiveForegroundColor: Colors.white,
                      activeForegroundColor: Colors.red,
                      activeBackgroundColor: Colors.white,
                      radius: Radius.circular(50),
                    ),
                    didChangeCount: (value) {
                      if (value < 1) {
                        Fluttertoast.showToast(
                            msg: "This quantity cannot be less than 1");
                        return;
                      }
                      setState(() {
                        countLmit = value;
                      });
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                widget.model!.itemTitle.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Colors.pinkAccent),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.normal,
                    fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "${widget.model!.price}",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.pink),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 320.0),
              child: Divider(
                height: 1,
                color: Colors.pinkAccent,
                thickness: 2,
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
