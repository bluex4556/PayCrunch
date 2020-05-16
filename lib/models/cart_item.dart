import 'package:flutter/foundation.dart';
import 'package:pay_crunch/models/product.dart';

class CartItem {
  final Product product;
  int qty;

  CartItem({
    @required this.product,
    this.qty = 1,
  });

  Map toJson() => {
        'product': {'name': product.name, 'price': product.price},
        'quantity': qty,
      };

  CartItem.fromJson(Map<String, dynamic> json)
      : this.product = new Product(name: json["product"]["name"], price: json["product"]["price"]),
        this.qty = json["quantity"];
}
