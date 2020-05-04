import 'package:flutter/material.dart';
import 'package:pay_crunch/models/cart_item.dart';
import 'package:pay_crunch/models/product.dart';
import 'package:pay_crunch/screens/cart_screen.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../models/user.dart';
import '../widget/main_drawer.dart';
import '../widget/balance_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User user = User(username: "me", password: "1234", balance: 1000);
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            BalanceCard(user.balance),
          ],
        ),
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
            new CartItem(username: user.username, product: scannedProduct));
      } else
        print(scannedProduct);
    });
  }
}
