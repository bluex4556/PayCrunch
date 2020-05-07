import 'package:flutter/material.dart';
import 'package:pay_crunch/auth_service.dart';

import 'screens/cart_screen.dart';
import 'screens/login_screen.dart';


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
      home: AuthService().handleAuth(),
      routes: {
        CartScreen.routeName: (_) => CartScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
      },
    );
  }
}
