import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GroupedStackedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final String ylabel;
  final int desiredMaxColumns;
  final int desiredMaxRows;
  var position;
  var outsideJustification;
  GroupedStackedBarChart(this.seriesList, this.ylabel, this.desiredMaxColumns, this.desiredMaxRows, this.position, this.outsideJustification);

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
        child: charts.BarChart(
          seriesList,
          animate: true,
          barGroupingType: charts.BarGroupingType.groupedStacked,
          behaviors: [
            new charts.SeriesLegend(
              desiredMaxColumns: desiredMaxColumns,//2,
              desiredMaxRows: desiredMaxRows,//12,
              position: position,//charts.BehaviorPosition.end,
              outsideJustification: outsideJustification,//charts.OutsideJustification.start,
              horizontalFirst: false,
              entryTextStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.black,
                  fontFamily: 'FiraSans',
                  fontSize: 18),
            ),
            new charts.ChartTitle(ylabel,
                behaviorPosition: charts.BehaviorPosition.start,
                titleStyleSpec: charts.TextStyleSpec(
                    fontSize: 18, fontFamily: 'FiraSans', color: charts.MaterialPalette.black),
                titleOutsideJustification:
                    charts.OutsideJustification.middleDrawArea)
          ],

          domainAxis: new charts.OrdinalAxisSpec(
              renderSpec: new charts.SmallTickRendererSpec(

                  // Tick and Label styling here.
                  labelStyle: new charts.TextStyleSpec(
                      fontSize: 18, // size in Pts.
                      fontFamily: 'FiraSans',
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
                      fontFamily: 'FiraSans',
                      color: charts.MaterialPalette.black),

                  // Change the line colors to match text color.
                  lineStyle: new charts.LineStyleSpec(
                      color: charts.MaterialPalette.black))),
        ));
  }
}
