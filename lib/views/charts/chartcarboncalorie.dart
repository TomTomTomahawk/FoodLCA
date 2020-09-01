import 'package:foodlca/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'standardchart.dart';

class ChartCarbonCalorie extends StatefulWidget {
  final int _recipeid;
  final String _recipename;

  ChartCarbonCalorie(this._recipeid, this._recipename);

  @override
  ChartCarbonCalorieState createState() {
    return new ChartCarbonCalorieState();
  }
}

class ChartCarbonCalorieState extends State<ChartCarbonCalorie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: DataProvider.getRecipeIngredientsList(widget._recipeid),
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

            ingredients_sorted.sort((a, b) =>
                b['datacarboncalorie'].toInt() -
                a['datacarboncalorie'].toInt());

            var colors = [];

            for (var i = 0; i <= ingredients_sorted.length ~/ 10; i++) {
              colors.add(charts.ColorUtil.fromDartColor(Colors.red[600]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.orange[400]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.yellow[400]));
              colors
                  .add(charts.ColorUtil.fromDartColor(Colors.lightGreen[300]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.green[500]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.teal[600]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.cyan[900]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.lightBlue[900]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.indigo[900]));
              colors.add(charts.ColorUtil.fromDartColor(Colors.purple[900]));
            }

            List<charts.Series<OrdinalImpacts, String>> datacarboncalorie = [];
            for (var i = 0; i < ingredients.length; i++) {
              datacarboncalorie.add(new charts.Series<OrdinalImpacts, String>(
                //id: ingredients[i]['name'].substring(0, 7),
                id: truncateWithEllipsis(11, ingredients_sorted[i]['name']),
                seriesCategory:
                    truncateWithEllipsis(11, ingredients_sorted[i]['name']),
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
            return (ingredients_sorted.length) <= 12
                ? GroupedStackedBarChart(
                    datacarboncalorie,
                    'g-CO\u2082-eq per kcal',
                    1,
                    12,
                    charts.BehaviorPosition.end,
                    charts.OutsideJustification.start)
                : GroupedStackedBarChart(
                    datacarboncalorie,
                    'g-CO\u2082-eq per kcal',
                    2,
                    (ingredients_sorted.length / 2).round(),
                    charts.BehaviorPosition.bottom,
                    charts.OutsideJustification.middleDrawArea);
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
