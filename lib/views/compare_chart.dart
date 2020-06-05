import 'package:chart_tuto/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CompareAnalyse2 extends StatefulWidget {
  final int _recipeid;
  final String _recipename;
  final int _comparerrecipeid;
  final String _comparerrecipename;

  CompareAnalyse2(this._recipeid, this._recipename, this._comparerrecipeid,
      this._comparerrecipename);

  @override
  CompareAnalyseState createState() {
    return new CompareAnalyseState();
  }
}

class CompareAnalyseState extends State<CompareAnalyse2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(widget._recipeid.toString()),
        title: Text('Comparing recipes'),
        //backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
          future: DataProvider.getCompareRecipeIngredientsList(
              widget._recipeid, widget._comparerrecipeid),
          builder: (context, snapshot) {
            final ingredients = snapshot.data;
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            var colors = [
              charts.ColorUtil.fromDartColor(Colors.purple[900]),
              charts.ColorUtil.fromDartColor(Colors.purple[400]),
              charts.ColorUtil.fromDartColor(Colors.blue[900]),
              charts.ColorUtil.fromDartColor(Colors.blue[400]),
              charts.ColorUtil.fromDartColor(Colors.green[900]),
              charts.ColorUtil.fromDartColor(Colors.green[400]),
              charts.ColorUtil.fromDartColor(Colors.yellow[900]),
              charts.ColorUtil.fromDartColor(Colors.yellow[400]),
              charts.ColorUtil.fromDartColor(Colors.orange[900]),
              charts.ColorUtil.fromDartColor(Colors.orange[400]),
              charts.ColorUtil.fromDartColor(Colors.red[900]),
              charts.ColorUtil.fromDartColor(Colors.red[400]),
            ];

            String truncateWithEllipsis(int cutoff, String myString) {
              return (myString.length <= cutoff)
                  ? myString
                  : '${myString.substring(0, cutoff)}...';
            }

            List<charts.Series<OrdinalImpacts, String>> data = [];
            for (var i = 0; i < ingredients.length; i++) {
              if (ingredients[i]['recipe_id'] == widget._recipeid) {
                data.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(6, ingredients[i]['name']),//ingredients[i]['name'].substring(0, 7),
                  //seriesCategory: 'A',
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) => colors[i],
                  data: [
                    new OrdinalImpacts(
                        '${widget._recipename}', ingredients[i]['id']),
                  ],
                ));
                
              } if (ingredients[i]['recipe_id'] == widget._comparerrecipeid) {
                data.add(new charts.Series<OrdinalImpacts, String>(
                  id: truncateWithEllipsis(6, ingredients[i]['name']), //ingredients[i]['name'].substring(0, 7),
                  //seriesCategory: 'A',
                  domainFn: (OrdinalImpacts sales, _) => sales.recipe,
                  measureFn: (OrdinalImpacts sales, _) => sales.impact,
                  colorFn: (_, __) => colors[i],
                  data: [
                    new OrdinalImpacts(
                        '${widget._comparerrecipename}', ingredients[i]['id']),
                  ],
                ));

              }
            }

            return GroupedStackedBarChart(
              data,
              // Disable animations for image tests.
              animate: false,
            );
          }),
    );
  }
}

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
        new charts.ChartTitle('kg-CO2-eq per calorie',
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
  final int impact;

  OrdinalImpacts(this.recipe, this.impact);
}
