import 'dart:ffi';

import 'package:chart_tuto/providers/data_provider.dart';
import 'package:chart_tuto/views/compare_list.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
          //backgroundColor: Colors.green,
        ),
        body: FutureBuilder(
            future: DataProvider.getRecipeIngredientsList(widget._recipeid),
            builder: (context, snapshot) {
              final ingredients = snapshot.data;
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              }
              var colors = [];
              if (ingredients.length <= 5) {
                colors = [
                  charts.ColorUtil.fromDartColor(Colors.red[900]),
                  charts.ColorUtil.fromDartColor(Colors.orange[900]),
                  charts.ColorUtil.fromDartColor(Colors.green[900]),
                  charts.ColorUtil.fromDartColor(Colors.blue[900]),
                  charts.ColorUtil.fromDartColor(Colors.purple[900]),
                ];
              }

              if (ingredients.length >= 6 && ingredients.length <= 10) {
                colors = [
                  charts.ColorUtil.fromDartColor(Colors.limeAccent[400]),
                  charts.ColorUtil.fromDartColor(Colors.green[600]),
                  charts.ColorUtil.fromDartColor(Colors.cyan[600]),
                  charts.ColorUtil.fromDartColor(Colors.blue[400]),
                  charts.ColorUtil.fromDartColor(Colors.indigo[900]),
                  charts.ColorUtil.fromDartColor(Colors.purple[900]),
                ];
              } //purple indigo blue cyan green limeAccent[400] yellow orange deep orange red

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
                  'datacalorie': ((ingredients[i]['quantity']) *
                      ingredients[i]['calorie_intensity']),
                  'datacarboncalorie': (ingredients[i]['carbon_intensity'] *
                      1000000 /
                      ingredients[i]['calorie_intensity']),
                });
              }
              ingredients_sorted.sort(
                  (a, b) => a['datacarbon'].toInt() - b['datacarbon'].toInt());
              //print(ingredients_sorted);

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
              print(ingredients_sorted);

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
                  colorFn: (_, __) => colors[i],
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
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Container(
                    height: 70,
                    color: Colors.white,
                    child: Text(
                      'Total carbon footprint: ' +
                          totalcarbon.toStringAsFixed(2) +
                          ' kg-CO2-eq' +
                          '\n' +
                          'Total calories: ' +
                          totalcalories.toStringAsFixed(0) +
                          ' cal' +
                          '\n' +
                          'Carbon footprint per calorie: ' +
                          (1000 * totalcarbon / totalcalories)
                              .toStringAsFixed(2) +
                          ' g-CO2-eq/cal',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(
                      width: 200.0,
                      height: 450.0,
                      child: GroupedStackedBarChartRecipe(
                        datacarbon,
                        // Disable animations for image tests.
                        animate: false,
                      )),
                  ExpansionTile(title: Text('More details'), children: <Widget>[
                    for (var i = 0; i < ingredients.length; i++)
                      new ListTile(
                          title: Text(ingredients_sorted[i]['name'] +
                              ': ' +
                              (ingredients_sorted[i]['quantity'] *
                                      ingredients_sorted[i]
                                          ['carbon_intensity'] /
                                      1000)
                                  .toString()+'kg-CO2-eq'))
                  ]),
                  Container(
                    height: 50,
                    color: Colors.white,
                  ),
                  SizedBox(
                      width: 200.0,
                      height: 500.0,
                      child: GroupedStackedBarChartCalories(
                        datacalorie,
                        // Disable animations for image tests.
                        animate: false,
                      )),
                  ExpansionTile(title: Text('More details'), children: <Widget>[
                    for (var i = 0; i < 5; i++)
                      new ListTile(title: Text('oh hello there'))
                  ]),
                  Container(
                    height: 50,
                    color: Colors.white,
                  ),
                  SizedBox(
                      width: 200.0,
                      height: 500.0,
                      child: GroupedStackedBarChartCarbonCalories(
                        datacarboncalorie,
                        // Disable animations for image tests.
                        animate: false,
                      )),
                  ExpansionTile(title: Text('More details'), children: <Widget>[
                    for (var i = 0; i < 5; i++)
                      new ListTile(title: Text('oh hello there'))
                  ]),
                  Container(
                    height: 50,
                    color: Colors.white,
                  ),
                ],
              );
            }),
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompareList(
                              widget._recipeid, widget._recipename)));
                },
                label: Text('Compare'),
                backgroundColor: Colors.purple,
              ),
            ),
          ],
        ));
  }
}

class GroupedStackedBarChartRecipe extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedStackedBarChartRecipe(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.groupedStacked,
      behaviors: [
        new charts.SeriesLegend(
          desiredMaxColumns: 4,
          desiredMaxRows: 3,
          position: charts.BehaviorPosition.top,
          outsideJustification: charts.OutsideJustification.middle,
          horizontalFirst: true,
          entryTextStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.black,
              //fontFamily: 'Georgia',
              fontSize: 18),
        ),
        new charts.ChartTitle('kg-CO2-eq',
            behaviorPosition: charts.BehaviorPosition.start,
            titleStyleSpec: charts.TextStyleSpec(
                fontSize: 18, color: charts.MaterialPalette.black),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea)
      ],

      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 18, // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))),

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 18, // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))),
    );
  }
}

class GroupedStackedBarChartCalories extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedStackedBarChartCalories(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.groupedStacked,
      behaviors: [
        new charts.SeriesLegend(
          desiredMaxColumns: 4,
          desiredMaxRows: 3,
          position: charts.BehaviorPosition.top,
          outsideJustification: charts.OutsideJustification.middle,
          horizontalFirst: true,
          entryTextStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.black,
              //fontFamily: 'Georgia',
              fontSize: 18),
        ),
        new charts.ChartTitle('Calories',
            behaviorPosition: charts.BehaviorPosition.start,
            titleStyleSpec: charts.TextStyleSpec(
                fontSize: 18, color: charts.MaterialPalette.black),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea)
      ],

      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 18, // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))),

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 18, // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))),
    );
  }
}

class GroupedStackedBarChartCarbonCalories extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedStackedBarChartCarbonCalories(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.groupedStacked,
      behaviors: [
        new charts.SeriesLegend(
          desiredMaxColumns: 4,
          desiredMaxRows: 3,
          position: charts.BehaviorPosition.top,
          outsideJustification: charts.OutsideJustification.middle,
          horizontalFirst: true,
          entryTextStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.black,
              //fontFamily: 'Georgia',
              fontSize: 18),
        ),
        new charts.ChartTitle('g-CO2-eq per calorie',
            behaviorPosition: charts.BehaviorPosition.start,
            titleStyleSpec: charts.TextStyleSpec(
                fontSize: 18, color: charts.MaterialPalette.black),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea)
      ],

      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 18, // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))),

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 18, // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))),
    );
  }
}

/// Sample ordinal data type.
class OrdinalImpacts {
  final String recipe;
  final num impact;

  OrdinalImpacts(this.recipe, this.impact);
}
