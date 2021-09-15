import 'package:flutter/material.dart';
import 'smallStockDisplay.dart';
import 'utils/constants.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'utils/getAllStocks.dart';
import 'utils/stockSearchDelegate.dart';
import 'utils/textDialogInput.dart';

class StockGroups extends StatefulWidget {
  @override
  _StockGroupsState createState() => _StockGroupsState();
}

class _StockGroupsState extends State<StockGroups> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  List<Widget> groups = [
    StockGroupDisplay.fromList(stockIDs: [2330,2454, 2303,2337], title: "半導體"),
    StockGroupDisplay.fromList(stockIDs: [1201,1203,1210,1216,1218,1219,1227], title: "食物"),
    StockGroupDisplay.fromList(stockIDs: [9958,9951,9945], title: "編號很大的"),
  ];

  initState(){
    groups.add(
      TextButton(
        child: Text("新增各股群"),
        onPressed: (){
          groups.insert(groups.length-1,StockGroupDisplay.fromList(stockIDs: [], title: '各股群 ${groups.length}'));
          setState((){});
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpandablePageView(
        controller: _controller,
        children: groups,
      )
    );
  }
}

class StockGroupDisplay extends StatefulWidget {
  late String title;
  late List<SmallStockDisplay> stocks;

  StockGroupDisplay({Key? key, required this.stocks, required this.title}) : super(key: key);
  @override
  StockGroupDisplay.fromList({required List<int> stockIDs, String title = "Group"}) {
    this.title= title;
    this.stocks = stockIDs.map(
          (stockID) => SmallStockDisplay(title: nameOfID(stockID), stockID: stockID.toString())
      ).toList();
  }

  @override
  _StockGroupDisplayState createState() => _StockGroupDisplayState();
}


// class stockInfo{
//   SmallStockDisplay child;
//   final key = GlobalKey();
//   stockInfo(this.child);
// }

class _StockGroupDisplayState extends State<StockGroupDisplay> {
  @override

  late List<SmallStockDisplay> stocks;
  late String title;
  late int displayType;

  initState(){
    displayType = 0;
    stocks = [];
    for (SmallStockDisplay e in widget.stocks) {
      this.stocks.add(SmallStockDisplay(
        route: e.route,
        title: e.title,
        stockID: e.stockID,
        initDisplayType: displayType,
      ));
    }
    this.title = widget.title;
  }

  bool editTitle = false;
  bool removeMode = false;
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(title, style: themeData.textTheme.headline3),
              IconButton(
                icon: Icon(Icons.edit_sharp),
                onPressed: () async {
                  final newTitle = await textDialogInput(
                    context,
                    title: '更新股票群名稱',
                    value: title,
                  );
                  setState((){
                    title = newTitle;
                  });
                }
              ),
              Expanded(
                child: Container(),
              ),

              IconButton(
                  icon: Icon(displayType == 2? Icons.view_comfy_sharp : Icons.view_agenda_sharp),
                  onPressed: (){
                    setState((){
                      displayType = 2-displayType;
                      // print(displayType);
                      stocks = stocks.map((SmallStockDisplay e) =>
                        SmallStockDisplay(
                          route: e.route,
                          title: e.title,
                          stockID: e.stockID,
                          initDisplayType: displayType,
                        )
                      ).toList();

                      // for (SmallStockDisplay e in stocks) {
                      //   e.smallStockDisplayState.currentState?.changeDisplay(displayType);
                      // }
                    });
                    print(stocks[0].initDisplayType);
                  }
              ),

              IconButton(
                icon: Icon(Icons.add_chart_sharp),
                onPressed: (){
                  Future<int?> newStockID = showSearch(
                    context: context,
                    delegate: StockSearchDelegate(),
                  );
                  newStockID.then(
                    (int? value) {
                      if (value != -1 && value != null) {
                        setState((){
                          this.stocks.add(SmallStockDisplay(
                            title: nameOfID(value),
                            stockID: value.toString(),
                            initDisplayType: displayType,
                          ));
                        });
                      }
                    }
                  );

                }
              ),

              IconButton(
                  icon: Icon(removeMode? Icons.check_circle_outline_sharp:
                    Icons.remove_circle_outline_sharp),
                  onPressed: (){
                    setState((){
                      removeMode = !removeMode;
                    });
                  }
              ),
            ],
          ),
          Container(
            child: Wrap(
              children: removeMode?
                stocks.map(
                    (SmallStockDisplay e) => Stack(
                      alignment: Alignment.center,
                      children: <Widget> [
                        ShakeAnimatedWidget(
                          enabled: true,
                          duration: Duration(milliseconds: 200),
                          shakeAngle: Rotation.deg(z:4),
                          child:e,
                        ),

                        IconButton(
                          padding: EdgeInsets.all(0),
                          iconSize: 60,
                          icon: Icon(Icons.highlight_remove_sharp),
                          onPressed: (){
                            setState((){
                              stocks.remove(e);
                              removeMode = false;
                            });
                          }
                        ),

                      ],
                    ),
                ).toList()
                  :stocks,
            ),
          )
        ],
      );
  }
}
