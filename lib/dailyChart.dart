import 'package:flutter/material.dart';
import 'dart:math';
import 'utils/getIP.dart';
import 'basicLineChart.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:k_chart/k_chart_widget.dart';
import 'dart:convert';

class DailyChart extends StatefulWidget {
  final int stockID;
  const DailyChart({Key? key, required this.stockID}) : super(key: key);

  @override
  _DailyChartState createState() => _DailyChartState();
}

class _DailyChartState extends State<DailyChart> {
  List<KLineEntity> ? datas;
  bool showLoading = true;
  @override
  void initState(){
    super.initState();
    getData();
  }

  void getData() {
    final Future<String> future = getIP(
        'https://autoquant.ai/api/v1/stock/ohlc/${widget.stockID}');
    future.then((String result) {
      final Map parseJson = json.decode(result) as Map<String, dynamic>;
      final list = parseJson['data']['ticks'];
      datas = list
          .map((item) =>
          KLineEntity.fromCustom(
            amount: item["Volume"].toDouble(),
            high: item["High"].toDouble(),
            low: item["Low"].toDouble(),
            open: item["Open"].toDouble(),
            close: item["Close"].toDouble(),
            vol: item["Volume"].toDouble(),
            time: DateTime
                .parse(item["Date"])
                .millisecondsSinceEpoch,
          ))
          .toList()
          .cast<KLineEntity>();
      DataUtil.calculate(datas!);
      showLoading = false;
      setState(() {});
    }).catchError((_) {
      showLoading = false;
      setState(() {});
      print('Data Error: $_');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    return Expanded(child:Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget> [
            Expanded(
              child: Stack(
                children: <Widget> [
                  Container(
                    child: BasicLineChart(
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

            )
          ],
        )
    ));
  }

  
}
