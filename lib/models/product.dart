import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String name;
  final int price;
  final String barCode;

  Product({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.barCode,
  });
}
