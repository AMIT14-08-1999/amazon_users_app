import 'package:amazon/models/items.dart';
import 'package:flutter/material.dart';

class CartItemDesignWidget extends StatefulWidget {
  Items? model;
  int? quantityNumber;
  CartItemDesignWidget({Key? key, this.model, this.quantityNumber})
      : super(key: key);

  @override
  State<CartItemDesignWidget> createState() => _CartItemDesignWidgetState();
}

class _CartItemDesignWidgetState extends State<CartItemDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shadowColor: Colors.white54,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Image.network(
                  widget.model!.thumbnailUrl.toString(),
                  width: 160,
                  height: 120,
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.model!.itemTitle.toString(),
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      //Price
                      Row(
                        children: [
                          const Text(
                            "Price: ",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 15,
                            ),
                          ),
                          const Text(
                            "₹ ",
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.model!.price.toString(),
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      //Quantity
                      Row(
                        children: [
                          const Text(
                            "Quantity: ",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            widget.quantityNumber.toString(),
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
