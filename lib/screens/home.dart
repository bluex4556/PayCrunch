import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../models/cart_item.dart';
import '../models/product.dart';
import '../screens/cart_screen.dart';
import '../models/user.dart';
import '../widget/main_drawer.dart';
import '../widget/balance_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userId;

  List<CartItem> cart = [
    CartItem(
      username: "me",
      product: Product(barCode: "1234", name: "testitem", price: 10),
      qty: 1,
    ),
  ];

  User addUser(String userId) {
    print("adding user");
    Firestore.instance
        .collection('users')
        .document(userId)
        .setData({'userId': userId, 'balance': 0});
    return User(username: userId, balance: 0);
  }

  Future<User> getCurrentUser() async {
    return _auth.currentUser().then((user) => Firestore.instance
            .collection('users')
            .document(user.uid)
            .get()
            .then((data) {
          print(data["balance"]);
          return new User(username: user.uid, balance: data['balance']);
        }).catchError((error) {
          return addUser(user.uid);
        }));
  }

  void addToCart(String barcode) {
    Firestore.instance
        .collection("products")
        .where("barcode", isEqualTo: barcode)
        .limit(1)
        .snapshots()
        .first
        .then((data) {
      DocumentSnapshot snapshot = data.documents.first;
      if (!snapshot.exists) print("exists");

      Product productToAdd = new Product(
        name: snapshot["name"],
        price: snapshot["price"],
        barCode: barcode,
      );
      int idx = cart.indexWhere((data) {
        return data.product.name == productToAdd.name;
      });
      if (idx == -1) {
        cart.add(new CartItem(
          product: productToAdd,
          username: userId,
          qty: 1,
        ));
      }
      else{
        cart[idx].qty++;
      }
    }).catchError((error) {
      print(error);
      print(barcode);
    });
  }

  @override
  void initState() {
    _auth.currentUser().then((user) {
      userId = user.uid;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text("Pay Crunch"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(CartScreen.routeName, arguments: cart);
              print("Go to cart");
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            User currentUser = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
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
