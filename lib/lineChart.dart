import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

class DateTimeValue{
  final DateTime dateTime;
  final double value;
  DateTimeValue(this.dateTime, this.value);
}
class LineChart extends StatefulWidget {
  final List<charts.Series<dynamic, DateTime> > seriesList;
  late double _minDist ;
  LineChart({required this.seriesList, Key? key}) : super(key: key);



  // factory LineChart.withList(List< List<DateTimeValue > > dt, List<>) {
  //
  // }

  @override
  _LineChartState createState() => _LineChartState();
  initState(){
    _minDist = 10;
  }
}

class _LineChartState extends State<LineChart> {
  @override
  double zoomLeft=20.0, zoomRight=0.0; // counting from newest
  static const double _zoomFactor = 0.35;
  Widget build(BuildContext context) {

    return GestureDetector(
      onScaleUpdate: (details) {
        double oldL = zoomLeft, oldR = zoomRight;
        double dst = zoomLeft - zoomRight;
        double chg = dst * details.scale * _zoomFactor;
        zoomLeft = min((zoomLeft + chg), widget.seriesList.length.toDouble());
        zoomRight= max((zoomRight - chg), 0.0);
        if (zoomLeft-zoomRight < widget._minDist) {
          zoomLeft = oldL;
          zoomRight = oldR;
        }else{
          setState((){
            zoomLeft;
            zoomRight;
          });
        }
      },
      child:
        charts.TimeSeriesChart(
          widget.seriesList,
          defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
          animate: true,
          dateTimeFactory: const charts.LocalDateTimeFactory(),
        )
    );
  }
}
