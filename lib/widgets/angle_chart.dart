import 'package:cyberlife/utils/angle_series.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AngleChart extends StatelessWidget {
  const AngleChart(this.data, {super.key});

  final List<AngleSeries> data;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: NumericAxis(
        isVisible: false, // Set the X-axis labels to be invisible
      ),
      series: <LineSeries<AngleSeries, int>>[
        LineSeries<AngleSeries, int>(
          dataSource: data,
          xValueMapper: (AngleSeries point, _) => point.id,
          yValueMapper: (AngleSeries point, _) => point.angle,
        ),
      ],
    );
  }
}
