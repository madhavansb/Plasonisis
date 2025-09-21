import 'package:flutter/material.dart';

class SchemeDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scheme Details")),
      body: Center(
        child: Text(
          "Scheme Details Content Here",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
