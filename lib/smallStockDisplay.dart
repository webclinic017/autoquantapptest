import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'realTimeChart.dart';
import 'dailyChart.dart';
import 'kChartTest.dart';
import 'bigValuePage.dart';
import 'utils/getIP.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:math';

class RealtimeDataTable extends StatefulWidget {
  List<dynamic> initTicks;
  RealtimeDataTable({required this.initTicks, Key? key}) : super(key: key);

  @override
  _RealtimeDataTableState createState() => _RealtimeDataTableState();
}

class _RealtimeDataTableState extends State<RealtimeDataTable> {
  @override
  late List<dynamic> ticks;
  late List<dynamic> fullTicks;
  int rowsDisplayed = 30;
  initState(){
    fullTicks = widget.initTicks;
    rowsDisplayed = 30;
  }
  bool isAscending = true;
  int sortColumn = 0;
  Widget build(BuildContext context){
    if (fullTicks == null) return Text("Waiting for API response");
    ticks = [];
    for (int i = 0; i<min(rowsDisplayed, fullTicks.length); ++i) {
      ticks.add(fullTicks[fullTicks.length - i - 1]);
    }
    return Column(children:[
      DataTable(
        sortAscending: isAscending,
        sortColumnIndex: sortColumn,
        columns: [
          DataColumn(
            label: Text('時間'),
            onSort: onSort,
          ),
          DataColumn(
            label: Text('高'),
            onSort: onSort,
          ),
          DataColumn(
            label: Text('低'),
            onSort: onSort,
          ),
          DataColumn(
            label: Text('量'),
            onSort: onSort,
          ),
        ],
        rows: ticks.map<DataRow>(
                (lst) => DataRow(
                cells: [
                  DataCell(Text(DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(lst[0].toInt(), isUtc:true)))),
                  DataCell(Text(lst[2].toString())),
                  DataCell(Text(lst[3].toString())),
                  DataCell(Text(lst[5].toString())),
                ]
            )
        ).toList(),
      ),
      TextButton(
        child: Text("顯示更多"),
        onPressed: (){
          rowsDisplayed += 100;
          setState((){});
        }
      )
    ]);
  }

  void onSort(int columnIndex, bool ascending) {

    int cmp(dynamic a, dynamic b) {
      return ascending? a.compareTo(b) : b.compareTo(a);
    }

    setState((){
      if (columnIndex == 0) {
        ticks.sort((b,a) => cmp(a[0], b[0]));
      }
      if (columnIndex == 1) {
        ticks.sort((a,b) => cmp(a[2], b[2]));
      }
      if (columnIndex == 2) {
        ticks.sort((a,b) => cmp(a[3], b[3]));
      }
      if (columnIndex == 3) {
        ticks.sort((a,b) => cmp(a[5], b[5]));
      }
      this.sortColumn = columnIndex;
      this.isAscending = ascending;
    });
  }

}


class SmallStockDisplay extends StatefulWidget {
  int duration = 0;
  Widget? route = null;
  String title;
  String stockID;
  bool singleStock;

  int initDisplayType;
  // 0: Basic Small View
  // 1: Basic Large View


  SmallStockDisplay ({Key? key, this.title='???', required this.stockID,
    this.route, this.initDisplayType = 0, this.singleStock = true}) : super(key: key) {
  }



  @override
  _SmallStockDisplayState createState() => _SmallStockDisplayState();
}

class _SmallStockDisplayState extends State<SmallStockDisplay> with TickerProviderStateMixin {
  @override
  double width=190;
  double height=180;
  Future<String> ? apiData;
  Map<String, dynamic> ? dataMap;
  String ? errorMessage;
  double ? marketChange;
  double ? marketChangePercent;
  double ? marketPrice;
  late int displayType;
  List<dynamic> ? ticks;

  Color toColor = COLOR_BLACK;

  initState()  {
    displayType = widget.initDisplayType;
    print(displayType);
    changeDisplay(displayType);
    widget.route = BigValueChart(stock: widget.stockID.toString(),);
    apiData = getIP(
        "https://autoquant.ai/api/v1/${widget.singleStock?"stock":"index"}/realtime/${widget.stockID}"
    );
    apiData!.then(
      (str) {

        dataMap = json.decode(str) as Map<String, dynamic>;
        Map<dynamic, dynamic> ? mapData = dataMap!['data'];
        if (mapData == null) {
          print("Weird: ${widget.stockID} is acting up");
          print(str);
        }
        ticks = mapData!['ticks'];
        marketChange = mapData['chartMarketChange'];
        marketChangePercent = mapData['chartMarketChangePercent'];
        marketPrice = mapData['chartMarketPrice'];
        if (marketChange! > 0) toColor = COLOR_RED;
        if (marketChange! < 0) toColor = COLOR_GREEN;
        setState((){});
      },
      onError: (e) {
        errorMessage = e;
      }
    ).catchError(
        (error) {
          print("Found error: $error");
        }
    );


  }

  void changeDisplay(int newDisplayType) {
    displayType = newDisplayType;
    print("Small stock ${widget.stockID} displayType $displayType");
    if (displayType == 0) {
      width = 190;
      height = 200;
    }
    if (displayType == 2) {
      width = 380;
      height = 50;
    }
    setState((){});
  }

  @override

  Widget Layout0(BuildContext context, Widget chart) {
    final ThemeData themeData = Theme.of(context);
    return Column(
      children: <Widget> [
        Center( child: Text(
          "${widget.title} ${widget.stockID}",
          style: themeData.textTheme.headline4,
        )),
        Expanded(
          child: chart,
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
                children: [
                  Text("${marketPrice!}", style: themeData.textTheme.bodyText2!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: toColor,
                  )),
                  Expanded(child: Container()),
                  Icon(Icons.arrow_drop_up_sharp),
                  // Column(children: [
                  //   Text("${marketChange!}", style: themeData.textTheme.bodyText2!.copyWith(
                  //     fontSize: 14,
                  //     color: toColor,
                  //   )),
                  //   Text("${marketChangePercent!}%", style: themeData.textTheme.bodyText2!.copyWith(
                  //     fontSize: 14,
                  //     color: toColor,
                  //   )),
                  // ])
                  Text("${marketChange!} (${marketChangePercent}%)", style: themeData.textTheme.bodyText2!.copyWith(
                    fontSize: 14,
                    color: toColor,
                  )),
                ]
            )

        )
      ],
    );
  }

  Widget Layout2(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Row(
      children: <Widget> [
        Text(
          "${widget.title} ${widget.stockID}",
          style: themeData.textTheme.headline4!.copyWith(
            color: themeData.primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 23,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Text("${marketPrice!}", style: themeData.textTheme.bodyText2!.copyWith(
          fontSize: 23,
          fontWeight: FontWeight.w400,
          color: toColor,
        )),
        Expanded(child: Container()),
        Icon(Icons.arrow_drop_up_sharp),
        Text("${marketChange!} (${marketChangePercent}%)", style: themeData.textTheme.bodyText2!.copyWith(
          fontSize: 20,
          color: toColor,
        )),

      ],
    );
  }

  Widget apiDead(){
    return Center(child: Text("Waiting for API response..."));
  }




  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);

    displayType = widget.initDisplayType;
    changeDisplay(displayType);

    final chart = FutureBuilder(
        future: apiData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RealTimeChart(stockID: widget.stockID.toString(), apiData: snapshot.data!.toString(), showBar: displayType==1);
          }else {
            return Center(
                child: CircularProgressIndicator());
          }

        }
    );



    if (displayType == 1) {
      // big display
      return Column(children: [
        Container(
          height:400,
          child: chart,
        ),
        ticks==null?Text("Waiting for API response"):RealtimeDataTable(initTicks: ticks!),
      ]);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        if (widget.route != null) {
          // print('hello');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.route!),
          );
        }
      },
      child: IgnorePointer(
        ignoring: true,
        child:AnimatedSize(
          curve: Curves.linear,
          vsync: this,
          duration: const Duration(milliseconds:200),
          child: Container (
              width: width,
              height: height,

              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                // border: Border.all(
                //   color: COLOR_GREY,
                // ),
                borderRadius: BorderRadius.circular(3),
                color: COLOR_WHITE,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: Offset(2,5),
                  )
                ],
              ),


              child: ((){
                if (marketChange == null) {
                  return apiDead();
                }
                switch (displayType) {
                  case 0: // default small view
                    return Layout0(context, chart);
                  case 2:
                    return Layout2(context);
                }

              }()),
          )
        )
      )
    );
  }
}
