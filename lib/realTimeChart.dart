/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'utils/getIP.dart';
import 'dart:convert';
import 'dart:math';

class RealTimeChart extends StatefulWidget {
  int stockID;
  bool showBar = false;
  RealTimeChart({required this.stockID, this.showBar=false, Key? key}) : super(key: key);
  @override
  _RealTimeChartState createState() => _RealTimeChartState();
}

class _RealTimeChartState extends State<RealTimeChart> {
  @override
  Future< List<charts.Series<dynamic, DateTime> > > ? seriesList;
  double scale = 0.0;
  bool priceIncrease = false;



  Future<List<charts.Series<dynamic, DateTime> > > getSeries() async{
    String res =
      await getIP("https://autoquant.ai/api/v1/stock/realtime/${widget.stockID}");
    final parseJson = json.decode(res) as Map<String, dynamic>;
    final ticks = parseJson['data']['ticks'];
    List<TimeValue> dataLine=[], dataBar=[];
    double largestLine=0, smallestLine = double.infinity, largestBar = 0;

    List<charts.Series<dynamic, DateTime> > ret = [];
    const int which = 1;
    for (List ele in ticks) {
      if (ele[which] != "N/A") {
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(ele[0].toInt());
        dataLine.add(TimeValue(dt, ele[which].toDouble()));
        largestLine = max(largestLine, ele[which].toDouble());
        smallestLine = min(smallestLine, ele[which].toDouble());
        largestBar = max(largestBar, ele[5].toDouble());
      }
    }

    if (!dataLine.isEmpty) {
      priceIncrease = dataLine.last.value > dataLine.first.value;
    }

    ret.add(
      charts.Series<TimeValue, DateTime> (
        id: 'Value',
        colorFn: (_, __) => priceIncrease?
          charts.MaterialPalette.red.shadeDefault:
          charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeValue tv, _) => tv.time,
        measureFn: (TimeValue tv, _) => tv.value,
        data: dataLine,
      )
    );

    if (widget.showBar) {
      scale = (largestLine-smallestLine+20) / largestBar * 0.3;
      for (List ele in ticks) {
        if (ele[which] != "N/A") {
          DateTime dt = DateTime.fromMillisecondsSinceEpoch(ele[0].toInt());
          dataBar.add(TimeValue(dt, ele[5].toDouble() * scale + smallestLine));
        }
      }
      ret.add(
        charts.Series<TimeValue, DateTime> (
          id: 'Trade Amount',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeValue tv, _) => tv.time,
          measureFn: (TimeValue tv, _) => tv.value,
          data: dataBar,
        )..setAttribute(charts.rendererIdKey, 'Bar Graph'),
      );
    }

    return ret;
  }

  void initState() {
    seriesList = getSeries();
  }

  Widget build(BuildContext context) {
    return Expanded(child: FutureBuilder<List<charts.Series<dynamic, DateTime> > >(
      future: seriesList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ShaderMask(
            child: charts.TimeSeriesChart(
              snapshot.data!,
              animate: true,
              dateTimeFactory: const charts.UTCDateTimeFactory(),
              domainAxis: charts.DateTimeAxisSpec(
                tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                  hour: charts.TimeFormatterSpec(
                    format: 'hh',
                    transitionFormat: 'HH',
                  )
                )
              ),
              defaultRenderer: new charts.LineRendererConfig(
                includeArea: true,
                strokeWidthPx: 1.0,
                roundEndCaps: true,
              ),
              customSeriesRenderers: [
                new charts.BarRendererConfig(
                    customRendererId: 'Bar Graph')
              ],
              primaryMeasureAxis: new charts.NumericAxisSpec(
                  tickProviderSpec:
                  new charts.BasicNumericTickProviderSpec(zeroBound: false)),

            ),
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [priceIncrease?
                  Colors.red[400]!:
                  Colors.green[400]!, priceIncrease?
                Colors.red[400]!:
                Colors.green[400]!],
              ).createShader(bounds);
            }
          );
        }else if (snapshot.hasError){
          return Text("$snapshot.error");
        }else{
          return CircularProgressIndicator();
        }
      }
    ));
  }
}


class TimeValue {
  final DateTime time;
  final double value;

  TimeValue(this.time, this.value);
}