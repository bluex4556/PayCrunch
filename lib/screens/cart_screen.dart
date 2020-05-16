import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pay_crunch/auth_service.dart';
import 'package:pay_crunch/screens/payment_screen.dart';
import 'package:pay_crunch/widget/app_bar_widget.dart';

import '../widget/cart_product.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int totalPrice = 0;
  List<CartItem> cart;

  @override
  void initState() {
    Firestore.instance
        .collection("users")
        .document(AuthService.userId)
        .get()
        .then((value) {
      setState(() {
        totalPrice = (value["cartPrice"] == null)? 0: value["cartPrice"];
      });
    });
    super.initState();
  }

  void increaseQuantityHandler(CartItem cartItem, int index) {
    Firestore.instance
        .collection("users")
        .document(AuthService.userId)
        .updateData({
      "cart": FieldValue.arrayRemove([
        jsonEncode(
          cartItem,
        )
      ]),
      "cartPrice": FieldValue.increment(cartItem.product.price),
    }).then((value) {
      cartItem.qty++;
      Firestore.instance.document("/users/${AuthService.userId}").updateData({
        "cart": FieldValue.arrayUnion([
          jsonEncode(
            cartItem,
          )
        ])
      });
    });

    setState(() {
      totalPrice += cartItem.product.price;
    });
  }

  void decreaseQuantityHandler(CartItem cartItem, int index) {
    if (cartItem.qty == 1) {
      //remove cart item
      Firestore.instance
          .collection("users")
          .document(AuthService.userId)
          .updateData({
        "cart": FieldValue.arrayRemove([
          jsonEncode(
            cartItem,
          )
        ]),
        "cartPrice": FieldValue.increment(-cartItem.product.price),
      });
    } else {
      //reduce qty by one
      Firestore.instance
          .collection("users")
          .document(AuthService.userId)
          .updateData({
        "cart": FieldValue.arrayRemove([
          jsonEncode(
            cartItem,
          )
        ]),
        "cartPrice": FieldValue.increment(-cartItem.product.price),
      }).then((value) {
        cartItem.qty--;
        Firestore.instance.document("/users/${AuthService.userId}").updateData({
          "cart": FieldValue.arrayUnion([
            jsonEncode(
              cartItem,
            )
          ])
        });
      });

    }
    setState(() {
      totalPrice -= cartItem.product.price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Cart",),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text("Qty"),
            ),
            title: Text("Product Name"),
            trailing: Text("Price"),
          ),
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection("/users")
                  .document(AuthService.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting) {

                  if(snapshot.data["cart"]==null)
                    return Text("No products in cart");
                  cart =
                      (snapshot.data["cart"] as List<dynamic>).map((element) {
                    return new CartItem.fromJson(jsonDecode(element));
                  }).toList();
                  return ListView.builder(
                    itemBuilder: (ctx, index) {
                      return CartProduct(
                        cartItem: cart[index],
                        index: index,
                        increaseQuantityHandler: increaseQuantityHandler,
                        decreaseQuantityHandler: decreaseQuantityHandler,
                      );
                    },
                    itemCount: cart.length,
                  );
                } else if (snapshot.hasError) {
                  return Text("error");
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          ListTile(
            title: Text("Total Cost"),
            trailing: Text("$totalPrice"),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: SizedBox(
          height: 50,
          child: FlatButton(
            disabledColor: Colors.black38,
            color: Theme.of(context).accentColor,
            child: Text("Check Out"),
            textColor: Colors.white,
            onPressed: (totalPrice==0)?null:() {
              Navigator.pushReplacementNamed(context, PaymentScreen.routeName,arguments: {
                "cart" : cart,
                "cost" : totalPrice,
              });
            },
          ),
        ),
      ),
    );
  }
}
