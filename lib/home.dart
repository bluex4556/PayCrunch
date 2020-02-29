import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String qrCode = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 120,
                child: DrawerHeader(
                  child: Text("Pay Crunch"),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                  ),
                  margin: EdgeInsets.zero,
                ),
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            "Pay Crunch",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: SelectableText(
            "$qrCode",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _scan,
          child: Icon(Icons.camera_alt),
        ),
      ),
    );
  }
  Future _scan() async{
    String qrCode = await scanner.scan();
    setState(() => this.qrCode = qrCode);
  }
}
