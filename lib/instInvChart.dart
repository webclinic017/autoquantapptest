import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'utils/getIP.dart';
import 'dart:convert';
import 'dart:math';
import 'utils/constants.dart';
import 'button.dart';

class InstInvHoldings extends StatefulWidget {
  int stockID;
  bool diff = false; // Graph 買賣超 if true, otherwise graph 持股
  InstInvHoldings({required this.stockID, required this.diff, Key? key}) : super(key: key);
  @override
  _InstInvHoldingsState createState() => _InstInvHoldingsState();
}

class DateTimeAxisSpecWorkaround extends charts.DateTimeAxisSpec {

  DateTimeAxisSpecWorkaround ({
    charts.RenderSpec<DateTime> ? renderSpec,
    charts.DateTimeTickProviderSpec ? tickProviderSpec,
    charts.DateTimeTickFormatterSpec ? tickFormatterSpec,
    bool ? showAxisLine,
    DateTime? startTime,
    viewport
  }) : super(
      renderSpec: renderSpec,
      tickProviderSpec: tickProviderSpec,
      tickFormatterSpec: tickFormatterSpec,
      showAxisLine: showAxisLine,
      viewport:viewport,) {
    // viewport: charts.OrdinalViewport(startTime,10);

  }

  @override
  void configure(charts.Axis<DateTime> axis, charts.ChartContext context,
      charts.GraphicsFactory graphicsFactory) {
    super.configure(axis, context, graphicsFactory);
    axis.autoViewport = false;
  }
}


class _InstInvHoldingsState extends State<InstInvHoldings> {
  @override
  Future< List<charts.Series<dynamic, DateTime> > > ? seriesList;
  late String who;
  String dataType = '持股(張)';
  int viewportDays = 30;
  static Map<String, dynamic> ColorMap = {
    '外資':Colors.blue[500],
    '投信':Colors.orange[500],
    '自營商':Colors.red[500],
  };

  List<dynamic> ? data;

  Future<List<charts.Series<dynamic, DateTime> > > getSeries(String who) async{
    if (data == null) {
      String res =
      await getIP(
          "https://autoquant.ai/api/v1/stock/inst_inv_trade/${widget.stockID}"
      );
      final parseJson = json.decode(res) as Map<String, dynamic>;
      final parseData = parseJson['data'];
      data = parseData['raw'];
    }

    print ('hi');


    List<charts.Series<dynamic, DateTime> > ret = [];
    List<String> toGet = who=='法人'?['外資','投信','自營商']:[who];

    for (String str in toGet) {
      String ask = str + dataType;
      List<TimeValue> graph = [];
      for (Map<dynamic, dynamic> mp in data!) {
        // print ('ho '+ask);
        DateTime date = DateTime.parse(mp['日期']);
        double value = mp[ask].toDouble();
        graph.add(TimeValue(date, value));
      }
      ret.add(
        charts.Series<dynamic, DateTime> (
          id: str,
          domainFn: (p, _) => p.time,
          measureFn: (p, _) => p.value,
          data: graph,
          colorFn: (p,__) => charts.ColorUtil.fromDartColor(
            dataType != '買賣超'?
            ColorMap[str] : (p.value < 0?COLOR_GREEN:COLOR_RED),
          ),
          // areaFn: (_,__) => charts.ColorUtil.fromDartColor(
          // ColorMap[str]
          // ),
        )
      );
    }
    return ret;
  }

  charts.AxisSpec<dynamic> myAxis () {
    return DateTimeAxisSpecWorkaround(
      viewport: charts.DateTimeExtents(start: DateTime.now().subtract(Duration(days:viewportDays)), end: DateTime.now()),
      tickProviderSpec: charts.AutoDateTimeTickProviderSpec(
        includeTime: true,
      ),
    );

  }

  void initState() {
    who = widget.diff?"外資":"法人";
    seriesList = getSeries(who);
    if (widget.diff) dataType = '買賣超';
  }

  Widget HoldingsChart(List<charts.Series<dynamic, DateTime> > data){
    return Container(
      // padding: EdgeInsets.only(right:10),
      // height:400,
      child: charts.TimeSeriesChart(
        data,
        animate: false,

        dateTimeFactory: const charts.UTCDateTimeFactory(),

        domainAxis: myAxis(),
        behaviors: [
          charts.PanAndZoomBehavior(),
          charts.SeriesLegend(),
        ],
        defaultRenderer: new charts.LineRendererConfig(
          includeArea: true,
          stacked: true,
          strokeWidthPx: 2,
          roundEndCaps: true,
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec:
          charts.BasicNumericTickProviderSpec(
            // zeroBound: false,
            desiredTickCount: 7,
          )),
      ),
    );
  }

  Widget DiffChart(List<charts.Series<dynamic, DateTime> > data){
    return Container(
      // padding: EdgeInsets.only(right:10),
      // height:400,
      child: charts.TimeSeriesChart(
        data,
        animate: false,

        dateTimeFactory: const charts.UTCDateTimeFactory(),

        domainAxis: myAxis(),
        behaviors: [
          charts.PanAndZoomBehavior(),
          charts.SeriesLegend(),
        ],
        defaultRenderer: new charts.BarRendererConfig(
          strokeWidthPx: 10,
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
            tickProviderSpec:
            charts.BasicNumericTickProviderSpec(
              // zeroBound: false,
              desiredTickCount: 7,
            )),

      ),
    );
  }

  Widget MyButton(String title, bool changeWho, String changeTo, {bool changeViewport = false}) {
    bool isSelected = false;
    if (changeViewport) {
      isSelected = viewportDays == int.parse(changeTo);
    }else{
      isSelected = (changeWho && who == changeTo) || (!changeWho && dataType == changeTo);
    }
    return Container(
      width: changeViewport?50:100,
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child:Button(
        key: ValueKey('${title}'),
        onPressed: (){
          setState((){
            if (changeViewport) {
              viewportDays = int.parse(changeTo);
            }else{
              if (changeWho) who = changeTo;
              else dataType = changeTo;
              seriesList = getSeries(who);
            }
          });
        },
        selected: isSelected,
        title: title,
      )
    );
  }

  Widget TimeChangeBar(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyButton('月', true, '30',changeViewport: true),
          MyButton('3月', true, '92',changeViewport: true),
          MyButton('6月', true, '183',changeViewport: true),
          MyButton('年', true, '365',changeViewport: true),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Container(child: FutureBuilder<List<charts.Series<dynamic, DateTime> > >(
        future: seriesList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (widget.diff == false) {
              return Column(children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyButton('三法人', true, '法人',),
                      MyButton('外資', true, '外資',),
                      MyButton('投信', true, '投信',),
                      MyButton('自營商', true, '自營商',),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyButton('張數', false, '持股(張)',),
                      MyButton('比率', false, '持股比率(%)',),
                      MyButton('市值(百萬)', false, '持股市值(百萬)',),
                    ],
                  ),
                ),

                Expanded(
                  child: HoldingsChart(snapshot.data!),

                ),

                TimeChangeBar(),
              ]);

            }else{
              dataType = '買賣超';
              return Column(children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // MyButton('三法人', true, '法人',),
                      MyButton('外資', true, '外資',),
                      MyButton('投信', true, '投信',),
                      MyButton('自營商', true, '自營商',),
                    ],
                  ),
                ),
                Expanded(
                  child: DiffChart(snapshot.data!),
                ),

                TimeChangeBar(),

              ]);
            }
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