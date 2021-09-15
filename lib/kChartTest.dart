import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:k_chart/chart_style.dart';
import 'package:k_chart/chart_translations.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:k_chart/k_chart_widget.dart';
import 'utils/constants.dart';
import 'utils/getAllStocks.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title, this.stockID = 2330}) : super(key: key);

  final String? title;
  int stockID;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<KLineEntity>? datas;
  bool showLoading = true;
  MainState _mainState = MainState.MA;
  bool _volHidden = false;
  SecondaryState _secondaryState = SecondaryState.Model;
  bool isLine = false;
  bool isChinese = false;
  bool _hideGrid = false;
  bool _showNowPrice = true;
  List<DepthEntity>? _bids, _asks;
  bool isChangeUI = false;

  final hi = Colors.redAccent;

  ChartStyle chartStyle = ChartStyle();
  ChartColors chartColors = ChartColors();

  @override
  void initState() {
    super.initState();
    chartColors.defaultTextColor = Color.fromRGBO(0, 0, 0, 1);
    chartColors.nowPriceTextColor = Color(0xff000000);
    chartColors.depthBuyColor = COLOR_GREEN;
    chartColors.depthSellColor = COLOR_RED;
    chartColors.maxColor = Color(0xff000000);
    chartColors.minColor = Color(0xff000000);
    Color crossTextColor = Color(0xff000000);
    chartColors.selectFillColor = Color.fromRGBO(100, 255, 255, 1);

    getData(widget.stockID);
    rootBundle.loadString('assets/depth.json').then((result) {
      final parseJson = json.decode(result);
      final tick = parseJson['tick'] as Map<String, dynamic>;
      final List<DepthEntity> bids = (tick['bids'] as List<dynamic>)
          .map<DepthEntity>(
              (item) => DepthEntity(item[0] as double, item[1] as double))
          .toList();
      final List<DepthEntity> asks = (tick['asks'] as List<dynamic>)
          .map<DepthEntity>(
              (item) => DepthEntity(item[0] as double, item[1] as double))
          .toList();
      initDepth(bids, asks);
    });
  }

  void getData(int stockID) async {
    showLoading = true;
    datas = await getKChartData(stockID,);
    showLoading = false;
    setState(() {});
  }

  void initDepth(List<DepthEntity>? bids, List<DepthEntity>? asks) {
    if (bids == null || asks == null || bids.isEmpty || asks.isEmpty) return;
    _bids = [];
    _asks = [];
    double amount = 0.0;
    bids.sort((left, right) => left.price.compareTo(right.price));
    //累加买入委托量
    bids.reversed.forEach((item) {
      amount += item.vol;
      item.vol = amount;
      _bids!.insert(0, item);
    });

    amount = 0.0;
    asks.sort((left, right) => left.price.compareTo(right.price));
    //累加卖出委托量
    asks.forEach((item) {
      amount += item.vol;
      item.vol = amount;
      _asks!.add(item);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return OrientationBuilder(
      builder: (context, orientation) {
      return Column(
      // shrinkWrap: true,
        children: <Widget>[
          Stack(children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: orientation!=Orientation.portrait?size.height - 50 : double.infinity,
              ),
              child:
                Container(
                  height: orientation==Orientation.portrait?450:350,
                  width: double.infinity,
                  color: Colors.white,
                  child: KChartWidget(
                    datas,
                    chartStyle,
                    chartColors,
                    isLine: isLine,
                    mainState: _mainState,
                    volHidden: _volHidden,
                    secondaryState: _secondaryState,
                    fixedLength: 2,
                    timeFormat: TimeFormat.YEAR_MONTH_DAY,
                    translations: kChartTranslations,
                    showNowPrice: _showNowPrice,
                    //`isChinese` is Deprecated, Use `translations` instead.
                    isChinese: isChinese,
                    hideGrid: _hideGrid,
                    maDayList: [5, 10, 20],
                    bgColor: [themeData.primaryColorLight, themeData.backgroundColor],
                  ),
                ),
            ),

        if (showLoading)
          Container(
              width: double.infinity,
              height: 450,
              alignment: Alignment.center,
              child: const CircularProgressIndicator()),
        ]),
        buildButtons(context),
        // if (_bids != null && _asks != null)
        //   Container(
        //     color: Colors.white,
        //     height: 230,
        //     width: double.infinity,
        //     child: DepthChart(_bids!, _asks!, chartColors),
        //   )
      ],
      );
    });
  }

  Widget buildButtons(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    TextStyle labelStyle = themeData.textTheme.headline3!.copyWith(fontWeight: FontWeight.w600, fontSize: 20);
    return Column(children: [
      Row( children:[
        Text("主圖線: ", style: labelStyle),
        Container(
            height: 50,
            width: 90,
            child: DropdownButton<MainState>(
                value: _mainState,
                icon: const Icon(Icons.arrow_downward_sharp),
                iconSize: 24,
                elevation: 16,
                style: themeData.textTheme.bodyText1,
                underline: Container(
                  height: 2,
                  color: themeData.accentColor,
                ),
                onChanged: (MainState? newValue) {
                  if (newValue!=null) setState((){
                    _mainState = newValue;
                  });
                },
                items: [
                  DropdownMenuItem(value: MainState.MA, child: Text("MA")),
                  DropdownMenuItem(value: MainState.BOLL, child: Text("BOLL")),
                  DropdownMenuItem(value: MainState.Model, child: Text("模型")),
                  DropdownMenuItem(value: MainState.NONE, child: Text("無")),
                ]
            )
        ),
        Container(width: 30),
        Text("副圖: ", style: labelStyle),
        Container(
            height: 50,
            width: 90,
            child: DropdownButton<SecondaryState>(
                value: _secondaryState,
                icon: const Icon(Icons.arrow_downward_sharp),
                iconSize: 24,
                elevation: 16,
                style: themeData.textTheme.bodyText1,
                underline: Container(
                  height: 2,
                  color: themeData.accentColor,
                ),
                onChanged: (SecondaryState? newValue) {
                  if (newValue!=null) setState((){
                    _secondaryState = newValue;
                  });
                },
                items: [
                  DropdownMenuItem(value: SecondaryState.Model, child: Text("模型")),
                  DropdownMenuItem(value: SecondaryState.ModelDiff, child: Text("模型差")),
                  DropdownMenuItem(value: SecondaryState.MACD, child: Text("MACD")),
                  DropdownMenuItem(value: SecondaryState.KDJ, child: Text("KDJ")),
                  DropdownMenuItem(value: SecondaryState.RSI, child: Text("RSI")),
                  DropdownMenuItem(value: SecondaryState.WR, child: Text("WR")),
                  DropdownMenuItem(value: SecondaryState.CCI, child: Text("CCI")),
                  DropdownMenuItem(value: SecondaryState.NONE, child: Text("無")),
                ]
            )
        ),

      ]),
        Row( children: [
          Text("格線:", style: labelStyle),
          Checkbox(
            value: !_hideGrid,
            onChanged: (bool? value) => setState((){_hideGrid = !value!;}),
          ),
          Text("量圖:", style: labelStyle),
          Checkbox(
            value: !_volHidden,
            onChanged: (bool? value) => setState((){_volHidden = !value!;}),
          ),
          Text("現值線:", style: labelStyle),
          Checkbox(
            value: _showNowPrice,
            onChanged: (bool? value) => setState((){_showNowPrice = value??_showNowPrice;}),
          ),
        ])
    ]);
  }

  Widget button(String text, {VoidCallback? onPressed}) {
    return TextButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
          setState(() {});
        }
      },
      child: Text(text),
      style: TextButton.styleFrom(
        primary: Colors.white,
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}