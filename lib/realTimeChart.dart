/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'utils/getIP.dart';
import 'dart:convert';
import 'dart:math';
import 'utils/constants.dart';
import 'utils/axisWorkaround.dart';

class RealTimeChart extends StatefulWidget {
  String stockID;
  bool showBar = false;
  bool singleStock;
  String? apiData;
  RealTimeChart({required this.stockID, this.showBar=false, this.singleStock=true, this.apiData, Key? key}) : super(key: key);
  @override
  _RealTimeChartState createState() => _RealTimeChartState();
}

class _RealTimeChartState extends State<RealTimeChart> {
  @override
  Future< List<charts.Series<dynamic, DateTime> > > ? seriesList;
  double scale = 0.0;
  bool priceIncrease = false;
  double prevClose = 0.0;
  bool drawUnder = false;

  Future<List<charts.Series<dynamic, DateTime> > > getSeries() async{

    String res = widget.apiData??
        await getIP(
            "https://autoquant.ai/api/v1/${widget.singleStock?"stock":"index"}/realtime/${widget.stockID}"
        );
    final parseJson = json.decode(res) as Map<String, dynamic>;
    final parseData = parseJson['data'];

    final ticks = parseData['ticks'];
    List<TimeValue> dataLine=[], dataBar=[];
    double largestLine=0, smallestLine = double.infinity, largestBar = 0;

    List<charts.Series<dynamic, DateTime> > ret = [];


    const int which = 1;

    prevClose = parseData['chartPreviousClose'];

    DateTime? startTime=null, endTime=null;



    int it = 0;
    for (List ele in ticks) {
      if (ele[which] != "N/A") {
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(ele[0].toInt());
        endTime = dt;
        if (startTime == null) startTime = dt;
        double value = ele[which].toDouble();
        if (value != prevClose)
          drawUnder = value > prevClose;
        dataLine.add(TimeValue.withColor(dt, value,
            ((){
              if (value > prevClose) {
                return COLOR_RED;
              }
              else if (value < prevClose) {
                return COLOR_GREEN;
              }
              else {
                try{
                  double nextValue = ticks[it+1][which].toDouble();
                  if (nextValue > prevClose) return COLOR_RED;
                  else if (nextValue < prevClose) return COLOR_GREEN;
                  else return COLOR_BLACK;
                }catch(e){
                  print(e);
                  return COLOR_BLACK;
                }

              }
            }()),
        ));

        largestLine = max(largestLine, ele[which].toDouble());
        smallestLine = min(smallestLine, ele[which].toDouble());
        largestBar = max(largestBar, ele[5].toDouble());
      }
      ++it;
    }



    if (!dataLine.isEmpty) {
      priceIncrease = dataLine.last.value > dataLine.first.value;
    }

    ret.add(
      charts.Series<TimeValue, DateTime> (
        id: 'Value',
        colorFn: (p, __) => charts.ColorUtil.fromDartColor(p.color),
        domainFn: (TimeValue tv, _) => tv.time,
        measureFn: (TimeValue tv, _) => tv.value,
        data: dataLine,
      )
    );



    if (widget.showBar) {
      // add moving average
      if (startTime != null) {
        List<TimeValue > MA30 = [];
        int index1 = 0, index2 = -1;
        double sum = 0;// fix cond later
        for (DateTime d = startTime; !endTime!.isBefore(d); d=d.add(Duration(minutes:1))) {
          // print("$d and $index1 and $index2" );
          while (index1 < dataLine.length && !d.subtract(Duration(minutes:30)).isBefore(dataLine[index1].time)) {
            sum -= dataLine[index1].value;
            ++index1;
          }
          while (index2+1 < dataLine.length && dataLine[index2+1].time.isBefore(d.add(Duration(minutes:30)))) {
            ++index2;
            sum += dataLine[index2].value;
          }

          MA30.add(TimeValue.withColor(d,sum/(index2-index1+1),Color(0x5f000000)));
        }

        ret.add(
          charts.Series<TimeValue, DateTime> (
            id: 'Value',
            colorFn: (p, __) => charts.ColorUtil.fromDartColor(p.color),
            domainFn: (TimeValue tv, _) => tv.time,
            measureFn: (TimeValue tv, _) => tv.value,
            data: MA30,
          )
        );
      }

      scale = (largestLine-smallestLine+20) / largestBar * 0.3;
      for (List ele in ticks) {
        if (ele[which] != "N/A") {
          DateTime dt = DateTime.fromMillisecondsSinceEpoch(ele[0].toInt());
          // dataBar.add(TimeValue(dt, ele[5].toDouble() * scale + smallestLine));
          dataBar.add(TimeValue(dt, ele[5].toDouble()));
        }
      }
      ret.add(
        charts.Series<TimeValue, DateTime> (
          id: 'Trade Amount',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeValue tv, _) => tv.time,
          measureFn: (TimeValue tv, _) => tv.value,
          data: dataBar,
        )..setAttribute(charts.measureAxisIdKey, charts.Axis.secondaryMeasureAxisId),
      );
    }
    return ret;
  }

  charts.AxisSpec<dynamic> myAxis(hasBar) => DateTimeAxisSpecWorkaround(

    tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
        hour: charts.TimeFormatterSpec(
          format: 'hh',
          transitionFormat: 'HH',
        )
    ),
    tickProviderSpec: charts.AutoDateTimeTickProviderSpec(
      includeTime: true,
    ),
    renderSpec: hasBar?null:charts.NoneRenderSpec(),
  );

  void initState() {
    seriesList = getSeries();
  }

  Widget getLineChart(data){
    return charts.TimeSeriesChart(
      data,
      animate: true,

      dateTimeFactory: const charts.UTCDateTimeFactory(),

      domainAxis: myAxis(widget.showBar),
      behaviors: [
        charts.PanAndZoomBehavior(),

        // charts.SeriesLegend(),
        charts.RangeAnnotation([
          charts.LineAnnotationSegment(
              prevClose, charts.RangeAnnotationAxisType.measure,

              labelPosition: charts.AnnotationLabelPosition.auto,
              labelDirection: charts.AnnotationLabelDirection.horizontal,
              startLabel: drawUnder?prevClose.toString():'',
              endLabel:   !drawUnder?prevClose.toString():'',
              dashPattern: [6,4],
              strokeWidthPx: 1.0,
              labelStyleSpec: charts.TextStyleSpec(fontSize: 10, color: charts.MaterialPalette.gray.shade600),
              // endLabel: 'Measure 1 End',
              color: charts.MaterialPalette.gray.shade400),
        ]),
      ],
      defaultRenderer: new charts.LineRendererConfig(
        includeArea: false,
        strokeWidthPx: 1.5,
        roundEndCaps: true,
      ),



      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: widget.showBar?null:charts.NoneRenderSpec(),
        tickProviderSpec:
          charts.BasicNumericTickProviderSpec(
            zeroBound: false,
            desiredTickCount: 3,
          )),
    );
  }

  Widget getBarChart(data) {
    return charts.TimeSeriesChart(
      data,
      animate: true,

      dateTimeFactory: const charts.UTCDateTimeFactory(),

      domainAxis: myAxis(widget.showBar),
      behaviors: [
        charts.PanAndZoomBehavior(),
      ],

      defaultRenderer: charts.BarRendererConfig<DateTime>(
        strokeWidthPx: 1.5,
      ),

      primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
          charts.BasicNumericTickProviderSpec(
            zeroBound: false,
            desiredTickCount: 3,
          )),


    );
  }

  Widget build(BuildContext context) {
    return Container(child: FutureBuilder<List<charts.Series<dynamic, DateTime> > >(
      future: seriesList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Column(children: [

              Expanded(
                flex: 2,
                child:getLineChart(!widget.showBar? [snapshot.data![0]]
                    : [snapshot.data![0],snapshot.data![1]]),
              ),

              widget.showBar? Expanded(flex:1, child:getBarChart([snapshot.data![2]])) : Container(),
            ])
          );
        }else if (snapshot.hasError){
          return Text("$snapshot.error");
        }else{
          return Center(
            child:CircularProgressIndicator(),
          );

        }
      }
    ));
  }
}


class TimeValue {
  final DateTime time;
  final double value;
  Color color= COLOR_WHITE;
  TimeValue(this.time, this.value);
  TimeValue.withColor(this.time, this.value, this.color);
}