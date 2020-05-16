import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pay_crunch/auth_service.dart';
import 'package:pay_crunch/models/cart_item.dart';

class PaymentScreen extends StatelessWidget {

  static const  routeName = "/payment-screen";

  Future<void> pay(int totalPrice,List<String> cart){
    return Firestore.instance.document("/users/${AuthService.userId}").collection("orders").document().setData(
      {
        'cart' : FieldValue.arrayUnion(cart),
        'price' : totalPrice,
        'date' : DateTime.now(),
      }
    ).then((value){
      print("test");
        Firestore.instance.document("/users/${AuthService.userId}").updateData(
        {
          "cart" : FieldValue.delete(),
          "cartPrice": FieldValue.delete(),
          "balance" : FieldValue.increment(-totalPrice),
        }
      ).catchError((s){print(s);});
    });
  }
  
  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> routeArgs =ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
    int totalPrice = routeArgs["cost"];
    List<CartItem> cart =  routeArgs["cart"];
    List<String> jsonCart = cart.map((cartItem) => jsonEncode(cartItem)).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
      ),
      body: FutureBuilder(
        future: pay(totalPrice, jsonCart),
        builder: (context,snapshot){
          print(snapshot.error);
          if(snapshot.connectionState == ConnectionState.done)
            {
              return Text("Payment Successful");
            }
          else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}
