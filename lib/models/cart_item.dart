import 'package:flutter/foundation.dart';

class CartItem {
  final String username;
  final String productId;
  int qty;

  CartItem({
    @required this.username,
    @required this.productId,
    this.qty = 1,
  });
}
