import 'dart:ffi';

import 'package:chart_tuto/providers/data_provider.dart';
import 'package:chart_tuto/views/compare_list.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'standardchart.dart';

class CompareChartCarbonCalorie extends StatefulWidget {
  final int _recipeid;
  final String _recipename;
  final int _comparerrecipeid;
  final String _comparerrecipename;

  CompareChartCarbonCalorie(this._recipeid, this._recipename,
      this._comparerrecipeid, this._comparerrecipename);

  @override
  CompareChartCarbonCalorieState createState() {
    return new CompareChartCarbonCalorieState();
  }
}

class CompareChartCarbonCalorieState extends State<CompareChartCarbonCalorie> {
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
            var colors = [];
            if (ingredients.length <= 20) {
              colors = [
                charts.ColorUtil.fromDartColor(Colors.lightGreen[300]),
                charts.ColorUtil.fromDartColor(Colors.green[500]),
                charts.ColorUtil.fromDartColor(Colors.teal[600]),
                charts.ColorUtil.fromDartColor(Colors.cyan[900]),
                charts.ColorUtil.fromDartColor(Colors.lightBlue[900]),
                charts.ColorUtil.fromDartColor(Colors.indigo[900]),
                charts.ColorUtil.fromDartColor(Colors.purple[900]),
                charts.ColorUtil.fromDartColor(Colors.lightGreen[300]),
                charts.ColorUtil.fromDartColor(Colors.green[500]),
                charts.ColorUtil.fromDartColor(Colors.teal[600]),
                charts.ColorUtil.fromDartColor(Colors.cyan[900]),
                charts.ColorUtil.fromDartColor(Colors.lightBlue[900]),
                charts.ColorUtil.fromDartColor(Colors.indigo[900]),
                charts.ColorUtil.fromDartColor(Colors.purple[900]),
              ];
            }

            String truncateWithEllipsis(int cutoff, String myString) {
              return (myString.length <= cutoff)
                  ? myString
                  : '${myString.substring(0, cutoff)}...';
            }

            String reciperetriever(int id) {
              if (ingredients[id]['recipe_id'] == widget._recipeid) {
              return widget._recipename;} else {return widget._comparerrecipename;}
            }

            var totalcarbon = 0.0;
            for (var i = 0; i < ingredients.length; i++) {
              totalcarbon = totalcarbon +
                  ingredients[i]['quantity'] *
                      ingredients[i]['carbon_intensity'] /
                      1000;
            }

            var totalcalories = 0.0;
            for (var i = 0; i < ingredients.length; i++) {
              totalcalories = totalcalories +
                  ingredients[i]['quantity'] *
                      ingredients[i]['calorie_intensity'] /
                      1000;
            }

            final List ingredients_sorted = [];
            for (var i = 0; i < ingredients.length; i++) {
              ingredients_sorted.add({
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

            ingredients_sorted.sort((a, b) =>
                b['datacarboncalorie'].toInt() -
                a['datacarboncalorie'].toInt());

            var ingredients_sortedcarboncalorie = [];

            for (var i = 0; i < ingredients.length; i++) {
              ingredients_sortedcarboncalorie.add(ingredients_sorted[i]);
            }

            List<charts.Series<OrdinalImpacts, String>> datacarboncalorie = [];

            for (var i = 0; i < ingredients.length; i++) {
              if (ingredients_sorted[i]['recipe_id'] == widget._recipeid) {
                datacarboncalorie.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(6, ingredients_sorted[i]['name']),
                  seriesCategory:
                      truncateWithEllipsis(6, ingredients_sorted[i]['name']),
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) => colors[i],
                  data: [
                    new OrdinalImpacts(
                        '${widget._recipename}'+'\n',
                        (ingredients_sorted[i]['carbon_intensity'] *
                            1000 /
                            ingredients_sorted[i]['calorie_intensity'])),
                  ],
                ));
              }
              if (ingredients_sorted[i]['recipe_id'] == widget._comparerrecipeid) {
                datacarboncalorie.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(
                      6,
                      ingredients_sorted[i]
                          ['name']), //ingredients[i]['name'].substring(0, 7),
                  seriesCategory:
                      truncateWithEllipsis(6, ingredients_sorted[i]['name']),
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) => colors[i],
                  data: [
                    new OrdinalImpacts(
                        '${widget._comparerrecipename}',
                        (ingredients_sorted[i]['carbon_intensity'] *
                            1000 /
                            ingredients_sorted[i]['calorie_intensity'])),
                  ],
                ));
              }
            }

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
                      'Impact per calorie',
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
                          datacarboncalorie,
                          // Disable animations for image tests.
                          'g-CO2-eq per calorie',
                        ))),
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
                                title: Text(ingredients_sortedcarboncalorie[i]
                                        ['name'] +
                                    ': ' +
                                    (ingredients_sortedcarboncalorie[i]
                                                ['carbon_intensity'] *
                                            1000 /
                                            ingredients_sortedcarboncalorie[i]
                                                ['calorie_intensity'])
                                        .toString() +
                                    ' kg-CO2-eq/calorie '+'(${reciperetriever(i)})'))
                        ])),
              ],
            );
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
