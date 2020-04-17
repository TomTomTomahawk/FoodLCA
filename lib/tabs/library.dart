import 'package:flutter/material.dart';

class Library extends StatelessWidget {
  const Library({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Libraryss"),
        backgroundColor: Colors.green,
      ),
      body: Container(child: Text('Here you have all your saved items', style: TextStyle(fontSize: 50.0))),
    );
  }
}