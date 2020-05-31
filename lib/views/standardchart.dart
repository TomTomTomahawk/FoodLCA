import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GroupedStackedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final String ylabel;

  GroupedStackedBarChart(this.seriesList, this.ylabel);

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
        child: charts.BarChart(
          seriesList,
          animate: true,
          barGroupingType: charts.BarGroupingType.groupedStacked,
          behaviors: [
            new charts.SeriesLegend(
              desiredMaxColumns: 4,
              desiredMaxRows: 5,
              position: charts.BehaviorPosition.top,
              outsideJustification: charts.OutsideJustification.middle,
              horizontalFirst: true,
              entryTextStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.black,
                  //fontFamily: 'Georgia',
                  fontSize: 18),
            ),
            new charts.ChartTitle(ylabel,
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
        ));
  }
}
