import 'package:chart_tuto/navigation_bar_controller.dart';
import 'package:chart_tuto/views/library_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LibraryList(),
    );
  }
}

