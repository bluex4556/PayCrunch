import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widget/cart_product.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems;
  int totalPrice = 0;

  void increaseQuantityHandler(int index) {
    setState(() {
      cartItems[index].qty++;
      totalPrice += cartItems[index].product.price;
    });
  }

  void decreaseQuantityHandler(CartItem cartItem, int index) {
    if (cartItem.qty == 1) {
      setState(() {
        cartItems.removeAt(index);
      });
    } else {
      setState(() {
        cartItems[index].qty--;
      });
    }
    totalPrice -= cartItems[index].product.price;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      cartItems = ModalRoute.of(context).settings.arguments as List<CartItem>;
      int price = 0;
      for (CartItem carItem in cartItems) {
        price += carItem.product.price * carItem.qty;
      }
      totalPrice = price;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      bottomNavigationBar: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 30),
                title: Text("Total"),
                subtitle: Text("$totalPrice"),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 50,
                child: FlatButton(
                  color: Theme.of(context).accentColor,
                  child: Text("Check Out"),
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Shopping Cart",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text("Qty"),
            ),
            title: Text("Product Name"),
            trailing: Text("Price"),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return CartProduct(
                  cartItem: cartItems[index],
                  index: index,
                  increaseQuantityHandler: increaseQuantityHandler,
                  decreaseQuantityHandler: decreaseQuantityHandler,
                );
              },
              itemCount: cartItems.length,
            ),
          ),
        ],
      ),
    );
  }
}
