import 'package:cyberlife/utilities/angle_series.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AngleChart extends StatelessWidget {
  AngleChart(this.data);

  final List<AngleSeries> data;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<AngleSeries, num>> series = [
      charts.Series(
          id: "angles",
          data: data,
          domainFn: (AngleSeries series, _) => series.id,
          measureFn: (AngleSeries series, _) => series.angle,
      )
    ];
    return charts.LineChart(series,
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.StaticNumericTickProviderSpec(
          <charts.TickSpec<num>>[
            charts.TickSpec<num>(0),
            charts.TickSpec<num>(20),
            charts.TickSpec<num>(40),
            charts.TickSpec<num>(60),
            charts.TickSpec<num>(80),
            charts.TickSpec<num>(100),
          ],
        ),
      ),);
  }
}