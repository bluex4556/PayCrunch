import 'package:flutter/foundation.dart';
import 'package:pay_crunch/models/product.dart';

class CartItem {
  final String username;
  final Product product;
  int qty;

  CartItem({
    @required this.username,
    @required this.product,
    this.qty = 1,
  });
}
