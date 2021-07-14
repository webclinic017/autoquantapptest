import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:k_chart/chart_style.dart';
import 'package:k_chart/chart_translations.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:k_chart/k_chart_widget.dart';


class BasicLineChart extends StatefulWidget {
  List<KLineEntity> ? datas;

  BasicLineChart({Key? key, required this.datas}) : super(key: key);

  @override
  _BasicLineChartState createState() => _BasicLineChartState();
}

class _BasicLineChartState extends State<BasicLineChart> {
  bool isLine = true;

  ChartStyle chartStyle = ChartStyle();
  ChartColors chartColors = ChartColors();
  
  initState(){
    chartColors.defaultTextColor = Color(0xff000000);
    chartColors.crossTextColor = Color(0xff000000);
    chartColors.selectBorderColor = Color(0xff6C7A86);
    chartColors.selectFillColor = Color(0xff0D1722);
    chartColors.lineFillColor = Color(0x554C86CD);
    chartColors.kLineColor = Color(0xff4C86CD);
  }
  
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return
        Container(
          width: double.infinity,
          child: KChartWidget(
            widget.datas,
            chartStyle,
            chartColors,
            isLine: isLine,
            mainState: MainState.NONE,
            volHidden: true,
            secondaryState: SecondaryState.NONE,
            fixedLength: 2,
            timeFormat: TimeFormat.YEAR_MONTH_DAY,
            translations: kChartTranslations,
            showNowPrice: true,
            hideGrid: false,
            maDayList: [5, 10, 20],
            bgColor: [themeData.primaryColorLight, themeData.backgroundColor],
          ),

    );
  }
}
