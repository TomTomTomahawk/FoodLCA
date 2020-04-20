
import 'package:flutter/material.dart';

class LibraryInheritedWidget extends InheritedWidget {

  final library = [/*{
      'name': 'hello',
      'draft': 0
    }*/];

  LibraryInheritedWidget(Widget child) : super(child: child);

  static LibraryInheritedWidget of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(LibraryInheritedWidget)as LibraryInheritedWidget);
  }

  @override
  bool updateShouldNotify( LibraryInheritedWidget oldWidget) {
    return oldWidget.library != library;
  }
}
