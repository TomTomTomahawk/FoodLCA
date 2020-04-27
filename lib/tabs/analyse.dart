import 'package:chart_tuto/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class Analyse extends StatelessWidget {
  const Analyse({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(createSampleData());

    return Scaffold(
      appBar: AppBar(
        title: Text("Analyse and compare"),
        backgroundColor: Colors.green,
      ),
      body: Container(
          child: GroupedStackedBarChart(
        createSampleData(),
        // Disable animations for image tests.
        animate: false,
      )),
    );
  }
}

// End of main

class GroupedStackedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedStackedBarChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.groupedStacked,
    );
  }
}

/// Sample ordinal data type.
class OrdinalImpacts {
  final String recipe;
  final int impact;

  OrdinalImpacts(this.recipe, this.impact);
}

//recipe id

/// Create series list with multiple series
List<charts.Series<OrdinalImpacts, String>> createSampleData() {
  final impactIngredientA = [
    new OrdinalImpacts('recipe name', 5),
  ];

  final impactIngredientB = [
    new OrdinalImpacts('recipe name', 25),
  ];

  final impactIngredientC = [
    new OrdinalImpacts('recipe name', 10),
  ];

  return [
    new charts.Series<OrdinalImpacts, String>(
      id: 'Ingredient A',
      seriesCategory: 'A',
      domainFn: (OrdinalImpacts sales, _) => sales.recipe,
      measureFn: (OrdinalImpacts sales, _) => sales.impact,
      data: impactIngredientA,
    ),
    new charts.Series<OrdinalImpacts, String>(
      id: 'Ingredient B',
      seriesCategory: 'A',
      domainFn: (OrdinalImpacts sales, _) => sales.recipe,
      measureFn: (OrdinalImpacts sales, _) => sales.impact,
      data: impactIngredientB,
    ),
    new charts.Series<OrdinalImpacts, String>(
      id: 'Ingredient C',
      seriesCategory: 'A',
      domainFn: (OrdinalImpacts sales, _) => sales.recipe,
      measureFn: (OrdinalImpacts sales, _) => sales.impact,
      data: impactIngredientC,
    ),
  ];
}
