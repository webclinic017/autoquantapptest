import 'package:flutter/material.dart';
import 'utils/getIP.dart';
import 'dart:convert';
import 'dart:math';
import 'bigValuePage.dart';
import 'button.dart';
import 'topBar.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'utils/getAllStocks.dart';
import 'basicKChart.dart';
import 'bigValuePage.dart' show StockBar;


class StockScreener extends StatefulWidget {
  const StockScreener({Key? key}) : super(key: key);

  @override
  _StockScreenerState createState() => _StockScreenerState();
}

enum ScreenType {Long, Short, LongShort, ShortLong}

class _StockScreenerState extends State<StockScreener> {
  @override

  ScreenType screenType = ScreenType.ShortLong;
  int shortDays = 2;
  int longDays = 2;

  bool isLoading = false;
  List<dynamic > ? data;

  Widget child = Container(height: 300, width:400, margin: EdgeInsets.all(15), child:
  Center(child: Text("無資料")));

  initState(){

  }

  void getData() async {
    isLoading = true;
    child = Center(child: CircularProgressIndicator());
    data = await getStockScreen(long : longDays, short: shortDays, shortFirst: screenType == ScreenType.ShortLong);
    isLoading = false;
    if (data != null){
      // child = QuickStockDisplay(stocks: data!, key: GlobalKey());
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenedStocksPage(stocks: data!)));
    }
    else
      child = Text ("Api Error");
    setState((){});
  }

  Widget choice(BuildContext context, bool long, int rangeStart){
    final ThemeData themeData = Theme.of(context);
    TextStyle labelStyle = themeData.textTheme.headline3!.copyWith(fontWeight: FontWeight.w600, fontSize: 20);
    return Row(children:[
      long?
        Text("看多: ", style: labelStyle.copyWith(color:Colors.redAccent)):
        Text("看空: ", style: labelStyle.copyWith(color:Colors.greenAccent)),
      Container(
        height: 50,
        width: 68,
        child: DropdownButton<int>(
          value: long?longDays:shortDays,
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
              if (long) longDays = newValue;
              else shortDays = newValue;
            });
          },
          items: List<DropdownMenuItem<int> >.generate(5,
                (i) => DropdownMenuItem(value: i+rangeStart, child: Text("${i+rangeStart} 天"))),
        )
      ),
    ]);
  }

  Widget getSelectors(BuildContext context){
    switch (screenType){
      case ScreenType.ShortLong:
        return Row(children:[
          choice(context, false, 1),
          Icon(Icons.arrow_right_alt_sharp),
          choice(context, true, 1),
        ]);
      case ScreenType.LongShort:
        return Row(children:[
          choice(context, true, 1),
          Icon(Icons.arrow_right_alt_sharp),
          choice(context, false, 1),
        ]);
      case ScreenType.Long:
        return choice(context, true, 5);
      case ScreenType.Short:
        return choice(context, false, 5);
    }
  }

  Widget filterOptionsWidget(BuildContext context){
    final ThemeData themeData = Theme.of(context);
    TextStyle labelStyle = themeData.textTheme.headline3!.copyWith(fontWeight: FontWeight.w600, fontSize: 20);
    return Column(children:[
      Row(children:[
        Text("篩選模式: ", style: labelStyle),
        Container(
            height: 50,
            width: 120,
            child: DropdownButton<ScreenType>(
                value: screenType,
                icon: const Icon(Icons.arrow_downward_sharp),
                iconSize: 24,
                elevation: 16,
                style: themeData.textTheme.bodyText1,
                underline: Container(
                  height: 2,
                  color: themeData.accentColor,
                ),
                onChanged: (ScreenType? newValue) {
                  if (newValue!=null) setState((){
                    screenType = newValue;
                    switch (screenType){
                      case ScreenType.ShortLong:
                      case ScreenType.LongShort:
                        shortDays=longDays=2;
                        break;
                      case ScreenType.Long:
                        shortDays=0;
                        longDays=6;
                        break;
                      case ScreenType.Short:
                        shortDays=6;
                        longDays=0;
                        break;
                    }
                  });
                },
                items: [
                  DropdownMenuItem(value: ScreenType.ShortLong, child: Text("看空轉看多")),
                  DropdownMenuItem(value: ScreenType.LongShort, child: Text("看多轉看空")),
                  DropdownMenuItem(value: ScreenType.Long, child: Text("連續看多")),
                  DropdownMenuItem(value: ScreenType.Short, child: Text("連續看空")),
                ]
            )
        ),
      ]),
      getSelectors(context),
    ]);
  }

  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    TextStyle labelStyle = themeData.textTheme.headline3!.copyWith(fontWeight: FontWeight.w600, fontSize: 20);



    return Column(children:[
      Row(children:[
        filterOptionsWidget(context),
        isLoading?Container():TextButton(
          style: TextButton.styleFrom(
            primary: themeData.primaryColorLight,
            backgroundColor: themeData.accentColor,
          ),
          child: Text("開始篩選", style: themeData.textTheme.headline2!.copyWith(
            fontSize: 25,
            color: themeData.primaryColorLight,
          )),
          onPressed: () {
            getData();
            setState((){});
          },
        ),
      ]),
      child,
    ]);
  }
}

class ScreenedStocksPage extends StatelessWidget {
  List<dynamic> stocks;
  ScreenedStocksPage({Key? key, required this.stocks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
        appBar:TopBar(title: '多空篩選股', subPage: true),
        body:Container(
          padding: EdgeInsets.only(left:5, right:5, top:15),
          child: QuickStockDisplay(stocks: stocks, key:GlobalKey()),

        )
    );
  }
}


class QuickStockDisplay extends StatefulWidget {
  List<dynamic > stocks;
  QuickStockDisplay({Key? key, required this.stocks}) : super(key: key);

  @override
  _QuickStockDisplayState createState() => _QuickStockDisplayState();
}

class _QuickStockDisplayState extends State<QuickStockDisplay> {
  @override

  int? curStock;
  String? stockName;
  List<KLineEntity>? datas;


  bool showLoading = false;

  Widget KChart = Container();

  void getData(int stockID) async {
    showLoading = true;
    setState((){});
    datas = await getKChartData(stockID);
    showLoading = false;
    // KChart =
    setState(() {});
  }


  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Column(children:[
      stockName==null?Container():StockBar(title:stockName!,stockID:curStock!),
      Stack(
        children: <Widget> [
          Container(
            height:300,
            child: BasicKChart(
            datas: datas,
          ),
        ),
        if (showLoading)
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: const CircularProgressIndicator()),
        if (curStock == null)
          Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text("未選股")),
        ]
      ),
      Expanded(child:
        ListView(children:
          widget.stocks.map<Widget>(
            ( mp) => Container(
              padding: EdgeInsets.all(5),
              child:ListTile(
                title: Text(mp['股票名稱'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                subtitle: Text(mp['股票代號']),
                tileColor: Colors.grey[300],
                selectedTileColor: themeData.primaryColorLight,
                onTap: (){
                  curStock = int.parse(mp['股票代號']);
                  stockName = mp['股票名稱'];
                  if (curStock != null) getData(curStock!);
                  setState((){});
                },
                selected: curStock == int.parse(mp['股票代號']),
              ),
            ),
          ).toList()
        ),
      )
    ]);
  }
}

class StockScreenPage extends StatelessWidget {
  const StockScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
        appBar:TopBar(title: '產業類股多空', subPage: true),
        body:Container(
          padding: EdgeInsets.only(left:5, right:5, top:15),
          child: SingleChildScrollView(
            child: StockScreener(),
          ),
        )
    );
  }
}
