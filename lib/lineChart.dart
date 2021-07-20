/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class realTimeChart extends StatefulWidget {
  const realTimeChart({Key? key}) : super(key: key);

  @override
  _realTimeChartState createState() => _realTimeChartState();
}

class _realTimeChartState extends State<realTimeChart> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;

  SimpleTimeSeriesChart({required this.seriesList, this.animate=false});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData() {
    return new SimpleTimeSeriesChart(
      seriesList: _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new charts.TimeSeriesChart(
      seriesList,
      animate: true,

      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeValue, DateTime>> _createSampleData() {
    final data = [
      new TimeValue(new DateTime(2017, 9, 19), 5),
      new TimeValue(new DateTime(2017, 9, 26), 25),
      new TimeValue(new DateTime(2017, 10, 3), 100),
      new TimeValue(new DateTime(2017, 10, 10), 75),
    ];

    return [
      charts.Series<TimeValue, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeValue sales, _) => sales.time,
        measureFn: (TimeValue sales, _) => sales.value,
        data: data,
      )
    ];
  }
}

class TimeValue {
  final DateTime time;
  final double value;

  TimeValue(this.time, this.value);
}