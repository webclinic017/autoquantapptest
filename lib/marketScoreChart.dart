import 'package:flutter/material.dart';
import 'package:k_chart/chart_style.dart';
import 'package:k_chart/chart_translations.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:k_chart/k_chart_widget.dart';
import 'basicLineChart.dart';
import 'utils/getAllStocks.dart';



class MarketScoreChart extends BasicLineChart {
  MarketScoreChart({Key? key}) : super(key: key, datas : []);

  Future<List<KLineEntity> > getData() async {
    // Future<List<KLineEntity>> ? datas;
    List<dynamic> lst = await getMarketScore();
    Map<double, double> modelMap = {};
    print("hmm");
    for (List<dynamic> t in lst) {
      if (double.tryParse(t[1].toString())!=null) {
        modelMap[t[0]/1000] = double.parse(t[1].toString());
        // print(double.parse(t[1]));
      }
    }
    // print ("so far so good");
    List<dynamic> list = await getMarketDaily('TWS:TSE01');
    print (list.length);
    List<KLineEntity> yo = list
        .map((item) =>
        KLineEntity.fromCustom(
          amount: 0,
          open: item[1].toDouble(),
          high: item[2].toDouble(),
          low: item[3].toDouble(),
          close: item[4].toDouble(),
          vol: 0,
          time: item[0].toInt(),
        )..modelvalue = modelMap[item[0].toDouble()]??0.5)
        .toList()
        .cast<KLineEntity>();
    DataUtil.calculate(yo);
    return yo;
  }

  @override
  Widget build(BuildContext context) {
    getData();

    // print (datas!.length);
    final ThemeData themeData = Theme.of(context);



    return FutureBuilder <List<KLineEntity> > (
      future: getData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Stack(
            children:[
              Container(
                width: double.infinity,
                child: KChartWidget(
                  null,
                  chartStyle,
                  chartColors,
                  isLine: false,
                  mainState: MainState.Model,
                  volHidden: true,
                  secondaryState: SecondaryState.ModelDiff,
                  fixedLength: 2,
                  timeFormat: TimeFormat.YEAR_MONTH_DAY,
                  translations: kChartTranslations,
                  showNowPrice: true,
                  hideGrid: false,
                  maDayList: [5, 10, 20],
                  bgColor: [themeData.primaryColorLight, themeData.backgroundColor],
                ),
              ),
              CircularProgressIndicator(),
            ]
          );
        }else{
          return Container(
            width: double.infinity,
            child: KChartWidget(
              snapshot.data!,
              chartStyle,
              chartColors,
              isLine: false,
              mainState: MainState.Model,
              volHidden: true,
              secondaryState: SecondaryState.ModelDiff,
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
    );
  }
}

