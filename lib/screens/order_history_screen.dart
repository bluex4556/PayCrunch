import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pay_crunch/auth_service.dart';
import 'package:pay_crunch/widget/app_bar_widget.dart';
import 'package:pay_crunch/widget/main_drawer.dart';

class OrderHistoryScreen extends StatelessWidget {
  static const routeName = "/order-history";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Order History"),
      drawer: MainDrawer("Orders"),
      body: StreamBuilder(
        stream: Firestore.instance
            .document("users/${AuthService.userId}")
            .collection("orders")
            .getDocuments()
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Text("te");
          }
        },
      ),
    );
  }
}
