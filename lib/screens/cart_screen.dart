import 'package:flutter/material.dart';
import 'package:pay_crunch/models/product.dart';
import 'package:pay_crunch/widget/cart_product.dart';

import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, Object> routeArgs;
  List<CartItem> cartItems;
  List<Product> products;
  int totalPrice = 0;

  void increaseQuantityHandler(int index) {
    setState(() {
      cartItems[index].qty++;
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
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      routeArgs =
      ModalRoute.of(context).settings.arguments as Map<String, Object>;
      cartItems = routeArgs["cart"];
      products = routeArgs["product"];
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
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
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                Product product = products.firstWhere((prod) {
                  if (prod.id == cartItems[index].productId)
                    return true;
                  else
                    return false;
                });
                return CartProduct(
                  cartItem: cartItems[index],
                  index: index,
                  product: product,
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
