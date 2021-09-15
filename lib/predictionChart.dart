import 'package:flutter/material.dart';
import 'utils/getIP.dart';
import 'basicKChart.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'utils/getAllStocks.dart';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

class PredictionChart extends StatefulWidget {
  final String stock;
  bool singleStock=true;
  PredictionChart({Key? key, required this.stock, this.singleStock=true}) : super(key: key);

  @override
  _PredictionChartState createState() => _PredictionChartState();
}

class _PredictionChartState extends State<PredictionChart> {
  int stockID=-1;
  List<KLineEntity> ? datas;
  bool showLoading = true;
  int longDays = 3, shortDays = 2;
  @override
  void initState(){
    super.initState();
    if (widget.singleStock) {
      stockID = int.parse(widget.stock);
    }
    getData(stockID);
  }

  void getData(int stockID) async {
    showLoading = true;
    setState((){});
    datas = await getKChartData(stockID,longDays: longDays, shortDays: shortDays);
    showLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    TextStyle labelStyle = themeData.textTheme.headline3!.copyWith(fontWeight: FontWeight.w600, fontSize: 20);
    return Container(
        // padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget> [
            Expanded(
              child: Stack(
                  children: <Widget> [
                    Container(
                      child: BasicKChart(
                        datas: datas,
                      ),
                    ),
                    if (showLoading)
                      Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator()),
                  ]
              ),

            ),
            Row(children:[
              Text("看多: ", style: labelStyle.copyWith(color: Colors.redAccent)),
              Container(
                height: 50,
                width: 75,
                child: DropdownButton<int>(
                  value: longDays,
                  icon: const Icon(Icons.arrow_downward_sharp),
                  iconSize: 24,
                  elevation: 16,
                  style: themeData.textTheme.bodyText1,
                  underline: Container(
                    height: 2,
                    color: themeData.accentColor,
                  ),
                  onChanged: (int? newValue) {
                    if (newValue!=null) setState((){
                      longDays = newValue;
                      getData(stockID);
                    });
                  },
                  items: [
                    DropdownMenuItem(value: 1, child: Text("1 天")),
                    DropdownMenuItem(value: 2, child: Text("2 天")),
                    DropdownMenuItem(value: 3, child: Text("3 天")),
                    DropdownMenuItem(value: 4, child: Text("4 天")),
                    DropdownMenuItem(value: 5, child: Text("5 天")),
                  ]
                )
              ),
              Text("看空: ", style: labelStyle.copyWith(color: Colors.greenAccent)),
              Container(
                  height: 50,
                  width: 75,
                  child: DropdownButton<int>(
                      value: shortDays,
                      icon: const Icon(Icons.arrow_downward_sharp),
                      iconSize: 24,
                      elevation: 16,
                      style: themeData.textTheme.bodyText1,
                      underline: Container(
                        height: 2,
                        color: themeData.accentColor,
                      ),
                      onChanged: (int? newValue) {
                        if (newValue!=null) setState((){
                          shortDays = newValue;
                          getData(stockID);
                        });
                      },
                      items: [
                        DropdownMenuItem(value: 1, child: Text("1 天")),
                        DropdownMenuItem(value: 2, child: Text("2 天")),
                        DropdownMenuItem(value: 3, child: Text("3 天")),
                        DropdownMenuItem(value: 4, child: Text("4 天")),
                        DropdownMenuItem(value: 5, child: Text("5 天")),
                      ]
                  )
              ),

            ])
          ],

        )
    );
  }
}


