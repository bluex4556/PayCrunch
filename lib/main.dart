import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pay_crunch/screens/cart_screen.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.blueAccent,
        fontFamily: "Raleway",
      ),
      home: Home(),
      routes: {
        CartScreen.routeName: (_) => CartScreen(),
      },
    );
  }
}
