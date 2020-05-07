import 'package:flutter/foundation.dart';

class User {
  final String username;
  int balance;

  User({
    @required this.username,
    this.balance = 10,
  });
}
