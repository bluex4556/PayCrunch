import 'package:flutter/foundation.dart';

class Product {
  final String name;
  final int price;
  final String barCode;

  Product({
    @required this.name,
    @required this.price,
    @required this.barCode,
  });
}
