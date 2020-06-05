import 'dart:math';
import 'package:chart_tuto/providers/data_provider.dart';
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

            ingredients_sorted1.sort((a, b) =>
                b['datacarboncalorie'].toInt() -
                a['datacarboncalorie'].toInt());

            ingredients_sorted2.sort((a, b) =>
                b['datacarboncalorie'].toInt() -
                a['datacarboncalorie'].toInt());

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

            List<charts.Series<OrdinalImpacts, String>> datacarboncalorie = [];

            if (ingredients_sorted1.length > ingredients_sorted2.length) {
              for (var i = 0; i < ingredients_sorted1.length; i++) {
                datacarboncalorie.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(11, ingredients_sorted1[i]['name']),
                  seriesCategory:i.toString(),
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) =>
                      colors[i],
                  /*fillPatternFn: (OrdinalImpacts sales, _) =>
            charts.FillPatternType.forwardHatch,*/
                  data: [
                    new OrdinalImpacts(
                        truncateWithEllipsis(8, widget._recipename),
                        (ingredients_sorted1[i]['carbon_intensity'] *
                            1000 /
                            ingredients_sorted1[i]['calorie_intensity'])),
                  ],
                ));
              }

              for (var i = 0; i < ingredients_sorted2.length; i++) {
                datacarboncalorie.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(
                      11,
                      ingredients_sorted2[i]
                          ['name']), //ingredients[i]['name'].substring(0, 7),
                  seriesCategory:i.toString(),
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) =>
                      colors[i],
                  data: [
                    new OrdinalImpacts(
                        truncateWithEllipsis(8, widget._comparerrecipename) +
                            '\n',
                        (ingredients_sorted2[i]['carbon_intensity'] *
                            1000 /
                            ingredients_sorted2[i]['calorie_intensity'])),
                  ],
                ));
              }
            } else {
              for (var i = 0; i < ingredients_sorted2.length; i++) {
                datacarboncalorie.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(
                      11,
                      ingredients_sorted2[i]
                          ['name']), //ingredients[i]['name'].substring(0, 7),
                  seriesCategory:i.toString(),
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) =>
                      colors[i],
                  data: [
                    new OrdinalImpacts(
                        truncateWithEllipsis(8, widget._comparerrecipename) +
                            '\n',
                        (ingredients_sorted2[i]['carbon_intensity'] *
                            1000 /
                            ingredients_sorted2[i]['calorie_intensity'])),
                  ],
                ));
              }

              for (var i = 0; i < ingredients_sorted1.length; i++) {
                datacarboncalorie.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(11, ingredients_sorted1[i]['name']),
                  seriesCategory:i.toString(),
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) =>
                      colors[i],
                  /*fillPatternFn: (OrdinalImpacts sales, _) =>
            charts.FillPatternType.forwardHatch,*/
                  data: [
                    new OrdinalImpacts(
                        truncateWithEllipsis(8, widget._recipename),
                        (ingredients_sorted1[i]['carbon_intensity'] *
                            1000 /
                            ingredients_sorted1[i]['calorie_intensity'])),
                  ],
                ));
              }
            }

/*
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
                        '${widget._recipename}' + '\n',
                        (ingredients_sorted[i]['carbon_intensity'] *
                            1000 /
                            ingredients_sorted[i]['calorie_intensity'])),
                  ],
                ));
              }
              if (ingredients_sorted[i]['recipe_id'] ==
                  widget._comparerrecipeid) {
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
            }*/

            return Container(
                color: Colors.white,
                child: ListView(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.04,
                        bottom: MediaQuery.of(context).size.width * 0.04,
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: 0),
                    child: Text('Carbon impact per calorie',
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
                              datacarboncalorie,
                              'kg-CO2-eq',
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
                              datacarboncalorie,
                              'kg-CO2-eq',
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
                                title: Text(ingredients_sortedcarboncalorie[i]
                                        ['name'] +
                                    ': ' +
                                    (ingredients_sortedcarboncalorie[i]
                                                ['carbon_intensity'] *
                                            1000 /
                                            ingredients_sortedcarboncalorie[i]
                                                ['calorie_intensity'])
                                        .toString() +
                                    ' kg-CO2-eq/calorie ' +
                                    '(${reciperetriever(i)})'))
                        ])),
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
