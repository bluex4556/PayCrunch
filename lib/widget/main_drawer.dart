import 'package:flutter/material.dart';
import 'package:pay_crunch/auth_service.dart';
import 'package:pay_crunch/screens/home.dart';
import 'package:pay_crunch/screens/order_history_screen.dart';

class MainDrawer extends StatelessWidget {
  final String currentScreen;
  MainDrawer(this.currentScreen);

  Widget buildDrawerTile(String title, IconData icon, Function tapHandler) {

    bool selected = (currentScreen==title);
    return Container(
      color: (selected)?Colors.grey:Colors.white,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: tapHandler,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            height: 150,
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: Text(
              "PayCrunch",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          buildDrawerTile("Home", Icons.category, () {
            Navigator.pushReplacementNamed(context, Home.routeName);
          }),
          buildDrawerTile("Orders", Icons.history, () {
            Navigator.pushReplacementNamed(
                context, OrderHistoryScreen.routeName);
          }),
          buildDrawerTile(
              "SignOut", Icons.exit_to_app, () => AuthService().signOut())
        ],
      ),
    );
  }
}
