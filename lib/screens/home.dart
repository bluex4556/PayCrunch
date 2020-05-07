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
  List<Product> productList = [
    Product(id: "1", barCode: "1234", name: "testitem", price: 10),
  ];
  List<CartItem> cart = [
    CartItem(
      username: "me",
      product: Product(id: "1", barCode: "1234", name: "testitem", price: 10),
      qty: 1,
    ),
  ];

  User addUser(String userId) {
    print("adding user");
    Firestore.instance
        .collection('users')
        .document()
        .setData({'userId': userId, 'balance': 0});
    return User(username: userId, balance: 0);
  }

  Future<User> getCurrentUser() async {
    return _auth.currentUser().then((user) => Firestore.instance
            .collection('users')
            .where("userId", isEqualTo: user.uid)
            .limit(1)
            .snapshots()
            .first
            .then((data) {
          DocumentSnapshot dataSnapshot = data.documents.first;
          return new User(
              username: dataSnapshot['userId'],
              balance: dataSnapshot['balance']);
        }).catchError((error) {
          print(error);
          return addUser(user.uid);
        }));
  }

  @override
  void initState() {
    _auth.currentUser().then((user){
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
              Navigator.of(context).pushNamed(CartScreen.routeName, arguments: {
                "cart": cart,
                "product": productList,
              });
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
            return CircularProgressIndicator();
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
    Product scannedProduct = productList.firstWhere((product) {
      if (product.barCode == scannedCode) return true;
      return false;
    });
    setState(() {
      if (scannedProduct != null) {
        cart.add(
            new CartItem(username: userId, product: scannedProduct));
      } else
        print(scannedProduct);
    });
  }
}
