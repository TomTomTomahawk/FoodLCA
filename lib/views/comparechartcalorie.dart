import 'dart:math';
import 'package:chart_tuto/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'standardchart.dart';

class CompareChartCalorie extends StatefulWidget {
  final int _recipeid;
  final String _recipename;
  final int _comparerrecipeid;
  final String _comparerrecipename;

  CompareChartCalorie(this._recipeid, this._recipename, this._comparerrecipeid,
      this._comparerrecipename);

  @override
  CompareChartCalorieState createState() {
    return new CompareChartCalorieState();
  }
}

class CompareChartCalorieState extends State<CompareChartCalorie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder(
          future: DataProvider.getCompareRecipeIngredientsList(
              widget._recipeid, widget._comparerrecipeid),
          builder: (context, snapshot) {
            final ingredients = snapshot.data;
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            String truncateWithEllipsis(int cutoff, String myString) {
              return (myString.length <= cutoff)
                  ? myString
                  : '${myString.substring(0, cutoff)}...';
            }

            var totalcalories = 0.0;
            for (var i = 0; i < ingredients.length; i++) {
              totalcalories = totalcalories +
                  ingredients[i]['quantity'] *
                      ingredients[i]['calorie_intensity'] /
                      1000;
            }

            final List ingredients_sorted1 = [];
            for (var i = 0; i < ingredients.length; i++) {
              if (ingredients[i]['recipe_id'] == widget._recipeid) {
                ingredients_sorted1.add({
                  'id': ingredients[i]['id'],
                  'name': ingredients[i]['name'],
                  'carbon_intensity': ingredients[i]['carbon_intensity'],
                  'calorie_intensity': ingredients[i]['calorie_intensity'],
                  'quantity': ingredients[i]['quantity'],
                  'unit': ingredients[i]['unit'],
                  'recipe_id': ingredients[i]['recipe_id'],
                  'datacarbon': ingredients[i]['quantity'] *
                      ingredients[i]['carbon_intensity'],
                  'datacalorie': (((ingredients[i]['quantity']) / 1000) *
                          ingredients[i]['calorie_intensity']) *
                      1000000,
                  'datacarboncalorie': (ingredients[i]['carbon_intensity'] *
                      1000000 /
                      ingredients[i]['calorie_intensity']),
                });
              }
            }

            final List ingredients_sorted2 = [];
            for (var i = 0; i < ingredients.length; i++) {
              if (ingredients[i]['recipe_id'] == widget._comparerrecipeid) {
                ingredients_sorted2.add({
                  'id': ingredients[i]['id'],
                  'name': ingredients[i]['name'],
                  'carbon_intensity': ingredients[i]['carbon_intensity'],
                  'calorie_intensity': ingredients[i]['calorie_intensity'],
                  'quantity': ingredients[i]['quantity'],
                  'unit': ingredients[i]['unit'],
                  'recipe_id': ingredients[i]['recipe_id'],
                  'datacarbon': ingredients[i]['quantity'] *
                      ingredients[i]['carbon_intensity'],
                  'datacalorie': (((ingredients[i]['quantity']) / 1000) *
                          ingredients[i]['calorie_intensity']) *
                      1000000,
                  'datacarboncalorie': (ingredients[i]['carbon_intensity'] *
                      1000000 /
                      ingredients[i]['calorie_intensity']),
                });
              }
            }
            ingredients_sorted1.sort(
                (a, b) => a['datacalorie'].toInt() - b['datacalorie'].toInt());

            ingredients_sorted2.sort(
                (a, b) => a['datacalorie'].toInt() - b['datacalorie'].toInt());

            var colors = [];

            for (var i = 0;
                i <=
                    (max(ingredients_sorted1.length,
                            ingredients_sorted2.length) ~/
                        10);
                i++) {
              colors.add(charts.ColorUtil.fromDartColor(Colors.purple[900]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.indigo[900]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.lightBlue[900]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.cyan[900]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.teal[600]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.green[500]));
              colors
                  .add(charts.ColorUtil.fromDartColor(Colors.lightGreen[300]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.yellow[400]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.orange[400]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.red[600]));
            }

            List<charts.Series<OrdinalImpacts, String>> datacalorie = [];

                        if (ingredients_sorted1.length > ingredients_sorted2.length) {
              for (var i = 0; i < ingredients_sorted1.length; i++) {
                datacalorie.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(11, ingredients_sorted1[i]['name']),
                  /*seriesCategory: reciperetriever(i),*/
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) =>
                      colors[ingredients_sorted1.length - i - 1],
                  /*fillPatternFn: (OrdinalImpacts sales, _) =>
            charts.FillPatternType.forwardHatch,*/
                  data: [
                    new OrdinalImpacts(
                        truncateWithEllipsis(8, widget._recipename),
                        ((ingredients_sorted1[i]['quantity'] / 1000) *
                            ingredients_sorted1[i]['calorie_intensity'])),
                  ],
                ));
              }

              for (var i = 0; i < ingredients_sorted2.length; i++) {
                datacalorie.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(
                      11,
                      ingredients_sorted2[i]
                          ['name']), //ingredients[i]['name'].substring(0, 7),
                  /*seriesCategory: reciperetriever(i),*/
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) =>
                      colors[ingredients_sorted2.length - i - 1],
                  data: [
                    new OrdinalImpacts(
                        truncateWithEllipsis(8, widget._comparerrecipename) +
                            '\n',
                        ((ingredients_sorted2[i]['quantity'] / 1000) *
                            ingredients_sorted2[i]['calorie_intensity'])),
                  ],
                ));
              }
            } else {
              for (var i = 0; i < ingredients_sorted2.length; i++) {
                datacalorie.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(
                      11,
                      ingredients_sorted2[i]
                          ['name']), //ingredients[i]['name'].substring(0, 7),
                  /*seriesCategory: reciperetriever(i),*/
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) =>
                      colors[ingredients_sorted2.length - i - 1],
                  data: [
                    new OrdinalImpacts(
                        truncateWithEllipsis(8, widget._comparerrecipename) +
                            '\n',
                        ((ingredients_sorted2[i]['quantity'] / 1000) *
                            ingredients_sorted2[i]['calorie_intensity'])),
                  ],
                ));
              }

              for (var i = 0; i < ingredients_sorted1.length; i++) {
                datacalorie.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(11, ingredients_sorted1[i]['name']),
                  /*seriesCategory: reciperetriever(i),*/
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) =>
                      colors[ingredients_sorted1.length - i - 1],
                  /*fillPatternFn: (OrdinalImpacts sales, _) =>
            charts.FillPatternType.forwardHatch,*/
                  data: [
                    new OrdinalImpacts(
                        truncateWithEllipsis(8, widget._recipename),
                        ((ingredients_sorted2[i]['quantity'] / 1000) *
                            ingredients_sorted2[i]['calorie_intensity'])),
                  ],
                ));
              }
            }
            return Container(
                color: Colors.white,
                child: ListView(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.04,
                        bottom: MediaQuery.of(context).size.width * 0.04,
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: 0),
                    child: Text('Calories',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                  (ingredients_sorted1.length + ingredients_sorted2.length) <=
                          12
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.73,
                          width: MediaQuery.of(context).size.width,
                          child: GroupedStackedBarChart(
                              datacalorie,
                              'kcal',
                              1,
                              12,
                              charts.BehaviorPosition.end,
                              charts.OutsideJustification.start),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.73 +
                              max(ingredients_sorted1.length,
                                      ingredients_sorted2.length) *
                                  MediaQuery.of(context).size.height *
                                  0.05,
                          width: MediaQuery.of(context).size.width,
                          child: GroupedStackedBarChart(
                              datacalorie,
                              'kcal',
                              2,
                              max(ingredients_sorted1.length,
                                  ingredients_sorted2.length),
                              charts.BehaviorPosition.bottom,
                              charts.OutsideJustification.middleDrawArea),
                        ),
                ]));
/*
            return ListView(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 75),
              children: <Widget>[
                Card(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    side: BorderSide(
                      color: Colors.black,
                      width: 0.0,
                    ),
                  ),
                  color: Colors.white,
                  child: Column(children: <Widget>[
                    Container(height: 10),
                    Text(
                      'Calories',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(height: 10),
                  ]),
                ),
                SizedBox(
                    width: 200.0,
                    height: 500.0,
                    child: Card(
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(
                            color: Colors.black,
                            width: 0.0,
                          ),
                        ),
                        color: Colors.white,
                        child: GroupedStackedBarChart(
                            datacalorie,
                            // Disable animations for image tests.
                            'Calories',
                            1,
                            12,
                            charts.BehaviorPosition.end,
                            charts.OutsideJustification.start))),
                Card(
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(
                        color: Colors.black,
                        width: 0.0,
                      ),
                    ),
                    color: Colors.white,
                    child: ExpansionTile(
                        title: Text('More details',
                            style: TextStyle(color: Colors.black)),
                        children: <Widget>[
                          for (var i = 0; i < ingredients.length; i++)
                            new ListTile(
                                title: Text(ingredients_sortedcalorie[i]
                                        ['name'] +
                                    ': ' +
                                    ((ingredients_sortedcalorie[i]['quantity'] /
                                                1000) *
                                            ingredients_sortedcalorie[i]
                                                ['calorie_intensity'])
                                        .toString() +
                                    ' calories ' +
                                    '(${reciperetriever(i)})'))
                        ])),
                Container(
                  height: 50,
                  color: Colors.transparent,
                ),
              ],
            );*/
          }),
    );
  }
}

/// Sample ordinal data type.
class OrdinalImpacts {
  final String recipe;
  final num impact;

  OrdinalImpacts(this.recipe, this.impact);
}
