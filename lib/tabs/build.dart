import 'package:chart_tuto/providers/data_provider.dart';
import 'package:chart_tuto/views/recipe_saver.dart';
import 'package:flutter/material.dart';

import 'package:chart_tuto/inherited_widgets/build_inherited_widget.dart';
import 'package:chart_tuto/views/build_list.dart';

class Build extends StatelessWidget {
  const Build({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BuildInheritedWidget(
      MaterialApp(
        title: 'Build',
        //home: SaveRecipe(),
        home: Tester(),
        //home: BuildList(), //DataProvider.getBuildMode() == 1 ? SaveRecipe() : BuildList(DataProvider.getBuildMode().toString()),
      ),
    );
  }
}

class Tester extends StatefulWidget {
  @override
  TesterState createState() {
    return new TesterState();
  }
}

class TesterState extends State<Tester> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: FutureBuilder(
        future: DataProvider.getCompareRecipeIngredientsList(1,3),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
      return Text('Number Of completed : ${snapshot.data}');
    }
    return Container();
        },
      ));
  }
}