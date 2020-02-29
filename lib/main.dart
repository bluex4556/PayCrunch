import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import './home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}


