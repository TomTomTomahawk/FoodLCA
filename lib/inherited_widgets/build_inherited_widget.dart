
import 'package:flutter/material.dart';

class BuildInheritedWidget extends InheritedWidget {

  final ingredients = [/*{
      'name': 'alpha',
      'carbon_intensity': 0,
      'calorie_intensity': 0,
      'quantity': 0,
      'recipe_id': 1
    }*/];

  BuildInheritedWidget(Widget child) : super(child: child);

  static BuildInheritedWidget of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BuildInheritedWidget)as BuildInheritedWidget);
  }

  @override
  bool updateShouldNotify( BuildInheritedWidget oldWidget) {
    return oldWidget.ingredients != ingredients;
  }
}
