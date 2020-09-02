import 'dart:math';
import 'package:foodlca/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'standardchart.dart';

class CompareChartCarbon extends StatefulWidget {
  final int _recipeid;
  final String _recipename;
  final int _comparerrecipeid;
  final String _comparerrecipename;

  CompareChartCarbon(this._recipeid, this._recipename, this._comparerrecipeid,
      this._comparerrecipename);

  @override
  CompareChartCarbonState createState() {
    return new CompareChartCarbonState();
  }
}

class CompareChartCarbonState extends State<CompareChartCarbon> {
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
                  : '${myString.substring(0, cutoff)}.';
            }

            String truncateWithDot(int cutoff, String myString) {
              return (myString.length <= cutoff)
                  ? myString
                  : '${myString.substring(0, myString[cutoff + 1] == ' ' ? cutoff + 1 : cutoff)}' +
                      '${myString[cutoff] == ' ' ? '\n' : myString[cutoff + 1] == ' ' ? '\n' : '-\n'}' +
                      '${myString.substring(myString[cutoff] == ' ' ? cutoff + 1 : myString[cutoff + 1] == ' ' ? cutoff + 2 : cutoff, (myString.length <= 2 * cutoff) ? myString.length : 2 * cutoff)}' +
                      '${(myString[cutoff] == ' ' && myString.length > 2 * cutoff) ? myString.substring(2 * cutoff, 2 * cutoff + 1) : ''}' +
                      '${(myString[cutoff + 1] == ' ' && myString.length > 2 * cutoff) ? myString.substring(2 * cutoff, 2 * cutoff + 1) : ''}' +
                      '${(myString[cutoff + 1] == ' ' && myString.length > 2 * cutoff + 1) ? myString.substring(2 * cutoff + 1, 2 * cutoff + 2) : ''}' +
                      '${(myString.length > 2 * cutoff && myString[cutoff] != ' ' && myString[cutoff + 1] != ' ') ? '.' : ''}' +
                      '${(myString.length == (2 * cutoff) + 2 && myString[cutoff] == ' ' && myString[cutoff + 1] != ' ') ? myString.substring(2 * cutoff + 1, 2 * cutoff + 2) : (myString[cutoff] == ' ' && myString[cutoff + 1] != ' ') ? '.' : ''}' +
                      '${(myString.length == (2 * cutoff) + 3 && myString[cutoff] != ' ' && myString[cutoff + 1] == ' ') ? myString.substring(2 * cutoff + 2, 2 * cutoff + 3) : (myString[cutoff + 1] == ' ' && myString[cutoff] != ' ') ? '.' : ''}';
            }

/*
String truncateWithDot(int max, String text) {

    if (text.length <= max)
        return text;

    // Start by chopping off at the word before max
    // This is an over-approximation due to thin-characters...
    int end = text.lastIndexOf(' ', max);

    // Just one long word. Chop it off.
    if (end == -1)
        return text.substring(0, max) + ".";

    // Step forward as long as textWidth allows.
    int newEnd = end;
    do {
        end = newEnd;
        newEnd = text.indexOf(' ', end + 1);

        // No more spaces.
        if (newEnd == -1)
            newEnd = text.length;

    } while (text.length < max);

    return text.substring(0, end) + ".";
}
*/
            var totalcarbon = 0.0;
            for (var i = 0; i < ingredients.length; i++) {
              totalcarbon = totalcarbon +
                  ingredients[i]['quantity'] *
                      ingredients[i]['carbon_intensity'] /
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
                (a, b) => a['datacarbon'].toInt() - b['datacarbon'].toInt());

            ingredients_sorted2.sort(
                (a, b) => a['datacarbon'].toInt() - b['datacarbon'].toInt());

            var colors = [];

            for (var i = 0;
                i <=
                    (max(ingredients_sorted1.length,
                            ingredients_sorted2.length) ~/
                        7);
                i++) {
              colors.add(charts.ColorUtil.fromDartColor(Colors.purple[900]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.indigo[900]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.lightBlue[900]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.cyan[900]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.teal[600]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.green[500]));
              colors
                  .add(charts.ColorUtil.fromDartColor(Colors.lightGreen[300]));
            }
            var colors2 = [];

            for (var i = 0;
                i <=
                    (max(ingredients_sorted1.length,
                            ingredients_sorted2.length) ~/
                        7);
                i++) {
              colors2.add(charts.ColorUtil.fromDartColor(Colors.pink[200]));
              colors2.add(charts.ColorUtil.fromDartColor(Colors.pink[900]));
              colors2.add(charts.ColorUtil.fromDartColor(Colors.red[900]));
              colors2.add(charts.ColorUtil.fromDartColor(Colors.orange[900]));
              colors2
                  .add(charts.ColorUtil.fromDartColor(Colors.deepOrangeAccent));
              colors2.add(charts.ColorUtil.fromDartColor(Colors.orange[400]));

              colors2.add(charts.ColorUtil.fromDartColor(Colors.amber[300]));
            }

            List<charts.Series<OrdinalImpacts, String>> datacarbon = [];

            if (ingredients_sorted1.length > ingredients_sorted2.length) {
              for (var i = 0; i < ingredients_sorted1.length; i++) {
                datacarbon.add(new charts.Series<OrdinalImpacts, String>(
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
                        truncateWithDot(6, widget._recipename),
                        ingredients_sorted1[i]['quantity'] *
                            ingredients_sorted1[i]['carbon_intensity']),
                  ],
                ));
              }

              for (var i = 0; i < ingredients_sorted2.length; i++) {
                datacarbon.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(
                      11,
                      ingredients_sorted2[i]
                          ['name']), //ingredients[i]['name'].substring(0, 7),
                  /*seriesCategory: reciperetriever(i),*/
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) =>
                      colors2[ingredients_sorted2.length - i - 1],
                  data: [
                    new OrdinalImpacts(
                        truncateWithDot(6, widget._comparerrecipename),
                        ingredients_sorted2[i]['quantity'] *
                            ingredients_sorted2[i]['carbon_intensity']),
                  ],
                ));
              }
            } else {
              for (var i = 0; i < ingredients_sorted2.length; i++) {
                datacarbon.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(
                      11,
                      ingredients_sorted2[i]
                          ['name']), //ingredients[i]['name'].substring(0, 7),
                  /*seriesCategory: reciperetriever(i),*/
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) =>
                      colors2[ingredients_sorted2.length - i - 1],
                  data: [
                    new OrdinalImpacts(
                        truncateWithDot(6, widget._comparerrecipename),
                        ingredients_sorted2[i]['quantity'] *
                            ingredients_sorted2[i]['carbon_intensity']),
                  ],
                ));
              }

              for (var i = 0; i < ingredients_sorted1.length; i++) {
                datacarbon.add(new charts.Series<OrdinalImpacts, String>(
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
                        truncateWithDot(6, widget._recipename),
                        ingredients_sorted1[i]['quantity'] *
                            ingredients_sorted1[i]['carbon_intensity']),
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
                    child: Text('Carbon impact',
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
                              datacarbon,
                              'g-CO\u2082-eq',
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
                              datacarbon,
                              'g-CO\u2082-eq',
                              2,
                              max(ingredients_sorted1.length,
                                  ingredients_sorted2.length),
                              charts.BehaviorPosition.bottom,
                              charts.OutsideJustification.middleDrawArea),
                        ),
                  (ingredients_sorted1.length + ingredients_sorted2.length) <=
                          12
                      ? Container()
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.06),
                ]));
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
