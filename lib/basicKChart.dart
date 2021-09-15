import 'package:flutter/material.dart';
import 'package:k_chart/chart_style.dart';
import 'package:k_chart/chart_translations.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:k_chart/k_chart_widget.dart';
import 'basicLineChart.dart';

class BasicKChart extends BasicLineChart {
  List<KLineEntity> ? datas;
  BasicKChart({required this.datas, Key? key}) : super(key: key, datas:datas);



  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return
      Container(
        width: double.infinity,
        child: KChartWidget(
          datas,
          chartStyle,
          chartColors,
          isLine: false,
          mainState: MainState.NONE,
          volHidden: true,
          secondaryState: SecondaryState.Model,
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

