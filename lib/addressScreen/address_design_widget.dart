import 'package:amazon/assistantMethods/address_changer.dart';
import 'package:amazon/models/address.dart';
import 'package:amazon/placeOrder/place_order_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressDesignWidget extends StatefulWidget {
  Address? address;
  int? index;
  int? value;
  String? addressID;
  double? totalAmount;
  String? sellerID;
  AddressDesignWidget(
      {Key? key,
      this.address,
      this.addressID,
      this.index,
      this.sellerID,
      this.totalAmount,
      this.value})
      : super(key: key);

  @override
  State<AddressDesignWidget> createState() => _AddressDesignWidgetState();
}

class _AddressDesignWidgetState extends State<AddressDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                groupValue: widget.index,
                value: widget.value!,
                activeColor: Colors.pink,
                onChanged: (val) {
                  Provider.of<AddressChanger>(context, listen: false)
                      .showSelectedAddress(val);
                },
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            const Text(
                              "Name: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(widget.address!.name.toString())
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Phone Number: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(widget.address!.phoneNumber.toString())
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              "Full Address: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(widget.address!.completeAddress.toString())
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          widget.value == Provider.of<AddressChanger>(context).count
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => PlaceOrderScreen(
                            addressID: widget.addressID,
                            totalAmount: widget.totalAmount,
                            sellerUID: widget.sellerID,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: const Text("Proceed"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
