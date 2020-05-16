import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay_crunch/widget/app_bar_widget.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../models/cart_item.dart';
import '../models/product.dart';
import '../screens/cart_screen.dart';
import '../models/user.dart';
import '../widget/main_drawer.dart';
import '../widget/balance_card.dart';
import '../auth_service.dart';

class Home extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void addToCart(String barcode) {
    Firestore.instance
        .collection("products")
        .document(barcode)
        .get()
        .then((data) {
      Product productToAdd = new Product(
        name: data["name"],
        price: data["price"],
        barCode: barcode,
      );
      Firestore.instance
          .collection("users")
          .document(AuthService.userId)
          .updateData({
        "cart": FieldValue.arrayUnion([
          jsonEncode(new CartItem(
            product: productToAdd,
          ))
        ]),
        "cartPrice": FieldValue.increment(productToAdd.price)
      });
    }).catchError((error) {
      print(error);
      print(barcode);
    });
  }

  @override
  void initState() {
    _auth.currentUser().then((user) {
      AuthService.userId = user.uid;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer("Home"),
      drawerScrimColor: Colors.black,
      appBar: AppBarWidget(
        title: "",
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: AuthService.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            User currentUser = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Pay Crunch",
                        style: Theme.of(context).textTheme.headline4),
                  ),
                  BalanceCard(currentUser.balance),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scan,
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Future _scan() async {
    String scannedCode = await scanner.scan();
    addToCart(scannedCode);
  }
}
