import 'package:amazon/itemsScreen/item_Screen.dart';
import 'package:amazon/models/brands.dart';
import 'package:flutter/material.dart';

class BrandsUiDesignWidget extends StatefulWidget {
  Brands? model;
  BrandsUiDesignWidget({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  State<BrandsUiDesignWidget> createState() => _BrandsUiDesignWidgetState();
}

class _BrandsUiDesignWidgetState extends State<BrandsUiDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => ItemsScreen(
              model: widget.model,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.black,
        elevation: 10,
        shadowColor: Colors.greenAccent,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      widget.model!.thumbnailUrl.toString(),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.model!.brandTitle.toString(),
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 3,
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
