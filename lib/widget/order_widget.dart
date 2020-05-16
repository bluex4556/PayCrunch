import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pay_crunch/models/cart_item.dart';
import 'package:pay_crunch/models/product.dart';

class OrderWidget extends StatefulWidget {
  final Map<String, dynamic> data;

  const OrderWidget(this.data);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool expanded = false;

  DateFormat dateFormat = new DateFormat.yMMMd().add_Hm();

  @override
  Widget build(BuildContext context) {
    List<CartItem> cart = [];
    List<dynamic> cartData = widget.data["cart"];
    cart = cartData.map((cartItem) {
      return CartItem.fromJson(jsonDecode(cartItem));
    }).toList();
    cart.add(CartItem(product: Product(name: "tt",price: 12),qty: 1));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("₹ ${widget.data["price"]}"),
              subtitle: Text(dateFormat.format(widget.data["date"].toDate())),
              trailing: IconButton(
                icon: (expanded)
                    ? Icon(Icons.keyboard_arrow_up)
                    : Icon(Icons.keyboard_arrow_down),
                onPressed: () {
                  if (expanded) {
                    setState(() {
                      expanded = false;
                    });
                  } else {
                    setState(() {
                      expanded = true;
                    });
                  }
                },
              ),
            ),
            (expanded)
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(cart[index].product.name),
                        trailing: Text("${cart[index].qty} x ${cart[index].product.price}"),
                      );
                    },
                    itemCount: cart.length,
                    shrinkWrap: true,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
