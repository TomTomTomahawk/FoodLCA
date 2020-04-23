import 'package:chart_tuto/inherited_widgets/library_inherited_widget.dart';
import 'package:chart_tuto/views/library_list.dart';
import 'package:flutter/material.dart';

class Library extends StatelessWidget {
  const Library({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LibraryInheritedWidget(
      MaterialApp(
        title: 'Library',
        home: LibraryList(),
      ),
    );
  }
}