import 'dart:ffi';

import 'package:chart_tuto/providers/data_provider.dart';
import 'package:chart_tuto/views/compare_list.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'standardchart.dart';

class Analyse2 extends StatefulWidget {
  final int _recipeid;
  final String _recipename;

  Analyse2(this._recipeid, this._recipename);

  @override
  AnalyseState createState() {
    return new AnalyseState();
  }
}

class AnalyseState extends State<Analyse2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //title: Text(widget._recipeid.toString()),
          title: Text('Analysing ' + widget._recipename),
          backgroundColor: Colors.green[900],
        ),
        backgroundColor: Colors.grey[100],
        body: FutureBuilder(
            future: DataProvider.getRecipeIngredientsList(widget._recipeid),
            builder: (context, snapshot) {
              final ingredients = snapshot.data;
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              }
              var colors = [];
              if (ingredients.length <= 7) {
                colors = [
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
                  'recipeid': ingredients[i]['recipe_id'],
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
              ingredients_sorted.sort(
                  (a, b) => a['datacarbon'].toInt() - b['datacarbon'].toInt());

              var ingredients_sortedcarbon = [];

              for (var i = ingredients.length - 1; i >= 0; i--) {
                ingredients_sortedcarbon.add(ingredients_sorted[i]);
              }

              List<charts.Series<OrdinalImpacts, String>> datacarbon = [];
              for (var i = 0; i < ingredients.length; i++) {
                datacarbon.add(new charts.Series<OrdinalImpacts, String>(
                  //id: ingredients[i]['name'].substring(0, 7),
                  id: truncateWithEllipsis(6, ingredients_sorted[i]['name']),
                  //seriesCategory: 'A',
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) => colors[i],
                  data: [
                    new OrdinalImpacts(
                        '',
                        ingredients_sorted[i]['quantity'] *
                            ingredients_sorted[i]['carbon_intensity'] /
                            1000)
                  ],
                ));
              }

              ingredients_sorted.sort((a, b) =>
                  a['datacalorie'].toInt() - b['datacalorie'].toInt());

              var ingredients_sortedcalorie = [];

              for (var i = ingredients.length - 1; i >= 0; i--) {
                ingredients_sortedcalorie.add(ingredients_sorted[i]);
              }
              List<charts.Series<OrdinalImpacts, String>> datacalorie = [];
              for (var i = 0; i < ingredients.length; i++) {
                datacalorie.add(new charts.Series<OrdinalImpacts, String>(
                  //id: ingredients[i]['name'].substring(0, 7),
                  id: truncateWithEllipsis(6, ingredients_sorted[i]['name']),
                  //seriesCategory: 'A',
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) => colors[i],
                  data: [
                    new OrdinalImpacts(
                        '',
                        ((ingredients_sorted[i]['quantity'] / 1000) *
                            ingredients_sorted[i]['calorie_intensity']))
                  ],
                ));
              }

              ingredients_sorted.sort((a, b) =>
                  b['datacarboncalorie'].toInt() -
                  a['datacarboncalorie'].toInt());

              var ingredients_sortedcarboncalorie = [];

              for (var i = 0; i < ingredients.length; i++) {
                ingredients_sortedcarboncalorie.add(ingredients_sorted[i]);
              }

              List<charts.Series<OrdinalImpacts, String>> datacarboncalorie =
                  [];
              for (var i = 0; i < ingredients.length; i++) {
                datacarboncalorie.add(new charts.Series<OrdinalImpacts, String>(
                  //id: ingredients[i]['name'].substring(0, 7),
                  id: truncateWithEllipsis(6, ingredients_sorted[i]['name']),
                  seriesCategory:
                      truncateWithEllipsis(6, ingredients_sorted[i]['name']),
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) => colors[colors.length - 1 - i],
                  data: [
                    new OrdinalImpacts(
                        '',
                        (ingredients_sorted[i]['carbon_intensity'] *
                            1000 /
                            ingredients_sorted[i]['calorie_intensity']))
                  ],
                ));
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
                        'Summary',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(height: 10),
                    ]),
                  ),
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
                        'Carbon impact: ' +
                            totalcarbon.toStringAsFixed(2) +
                            ' kg-CO2-eq' +
                            '\n' +
                            'Calories: ' +
                            totalcalories.toStringAsFixed(0) +
                            ' cal' +
                            '\n' +
                            'Impact per calorie: ' +
                            (1000 * totalcarbon / totalcalories)
                                .toStringAsFixed(2) +
                            ' g-CO2-eq/cal',
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(height: 10),
                    ]),
                  ),
                  Container(
                    height: 50,
                    color: Colors.transparent,
                  ),
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
                        'Carbon impact',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                            datacarbon,
                            // Disable animations for image tests.
                            'kg-CO2-eq',
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
                                  title: Text(ingredients_sortedcarbon[i]
                                          ['name'] +
                                      ': ' +
                                      (ingredients_sortedcarbon[i]['quantity'] *
                                              ingredients_sortedcarbon[i]
                                                  ['carbon_intensity'] /
                                              1000)
                                          .toString() +
                                      ' kg-CO2-eq'))
                          ])),
                  Container(
                    height: 50,
                    color: Colors.transparent,
                  ),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                                  title: Text(ingredients_sortedcalorie[i]
                                          ['name'] +
                                      ': ' +
                                      ((ingredients_sortedcalorie[i]
                                                      ['quantity'] /
                                                  1000) *
                                              ingredients_sortedcalorie[i]
                                                  ['calorie_intensity'])
                                          .toString() +
                                      ' calories'))
                          ])),
                  Container(
                    height: 50,
                    color: Colors.transparent,
                  ),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                                      ' kg-CO2-eq/calorie'))
                          ])),
                ],
              );
            }),
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                  height: 60,
                  width: 60,
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompareList(
                                  widget._recipeid, widget._recipename)));
                    },
                    child: Icon(Icons.compare_arrows, size: 32),
                    backgroundColor: Colors.black,
                  )),
            ),
          ],
        ));
  }
}

/// Sample ordinal data type.
class OrdinalImpacts {
  final String recipe;
  final num impact;

  OrdinalImpacts(this.recipe, this.impact);
}
