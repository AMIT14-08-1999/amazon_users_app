import 'package:amazon/assistantMethods/cart_item_counter.dart';
import 'package:amazon/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CartMethods {
  addItemCart(String? itemId, int itemCounter, BuildContext context) {
    List<String>? tempList = sharedPreferences!.getStringList("userCart");
    tempList!.add(itemId.toString() + ":" + itemCounter.toString()); //2367121:5

    //save to firestore database
    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .update({
      "userCart": tempList,
    }).then((value) {
      Fluttertoast.showToast(msg: "Item added successfully.");

      //save to local storage
      sharedPreferences!.setStringList("userCart", tempList);

      //update item badge number
      Provider.of<CartItemCounter>(context, listen: false)
          .showCartListItemsNumber();
    });
  }

  clearCart(BuildContext context) {
    sharedPreferences!.setStringList("userCart", ["initialValue"]);
    List<String>? emptyCartList = sharedPreferences!.getStringList("userCart");
    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .update({
      "userCart": emptyCartList,
    }).then((value) {
      Provider.of<CartItemCounter>(context, listen: false)
          .showCartListItemsNumber();
    });
  }

  separateItemIDUserCartList() {
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");
    List<String> itemsIDsList = [];
    for (var i = 1; i < userCartList!.length; i++) {
      String item = userCartList[i].toString();
      var lastCharPosItemBeforeColon = item.lastIndexOf(":");
      String getItemId = item.substring(0, lastCharPosItemBeforeColon);
      itemsIDsList.add(getItemId);
    }
    return itemsIDsList;
  }

  separateItemQuantityFromUserCartList() {
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");
    List<int> itemsQuantityList = [];
    for (var i = 1; i < userCartList!.length; i++) {
      String item = userCartList[i].toString();
      var colonAfterCharacterList = item.split(":").toList();
      var quantityNumber = int.parse(colonAfterCharacterList[1].toString());
      itemsQuantityList.add(quantityNumber);
    }
    return itemsQuantityList;
  }

  separateOrderItemIDs(productIDs) {
    List<String>? userCartList = List<String>.from(productIDs);
    List<String> itemsIDsList = [];
    for (var i = 1; i < userCartList.length; i++) {
      String item = userCartList[i].toString();
      var lastCharPosItemBeforeColon = item.lastIndexOf(":");
      String getItemId = item.substring(0, lastCharPosItemBeforeColon);
      itemsIDsList.add(getItemId);
    }
    return itemsIDsList;
  }

  separateOrderItemQuantity(productIDs) {
    List<String>? userCartList = List<String>.from(productIDs);
    List<String> itemsQuantityList = [];
    for (var i = 1; i < userCartList.length; i++) {
      String item = userCartList[i].toString();
      var colonAfterCharacterList = item.split(":").toList();
      var quantityNumber = int.parse(colonAfterCharacterList[1].toString());
      itemsQuantityList.add(quantityNumber.toString());
    }
    return itemsQuantityList;
  }
}
