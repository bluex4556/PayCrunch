import 'package:flutter/foundation.dart';

class User {
  final String username;
  final String password;
  int balance;

  User({
    @required this.username,
    @required this.password,
    this.balance = 0,
  });
}
