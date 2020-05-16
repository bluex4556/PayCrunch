import 'package:flutter/foundation.dart';

class Product {
  final String name;
  final int price;
  final String barCode;

  Product({
    @required this.name,
    @required this.price,
    this.barCode,
  });

  Product.fromJson(Map<String,dynamic> json):
      name = json["name"],
      price= json["price"],
      barCode = null;
}
