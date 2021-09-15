import 'package:flutter/material.dart';
import 'kChartTest.dart';
import 'realTimeChart.dart';
import 'utils/getAllStocks.dart';
import 'topBar.dart';
import 'dart:math';
import 'newsDisplay.dart';
import 'displayContainer.dart';
import 'utils/newsInfo.dart';
import 'utils/getNews.dart';
import 'utils/constants.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'incomeTables.dart';


import 'instInvChart.dart';
import 'button.dart';
import 'smallStockDisplay.dart';
import 'predictionChart.dart';


class ModelAspectBar extends StatelessWidget {
  String title;
  double value;
  bool small;
  ModelAspectBar(this.title, this.value,  {Key? key, this.small = true} ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value < 0.0 || value > 1.0) {
      print ("death from $value");
    }
    return Container(
      padding: EdgeInsets.only(left:5,),
      margin: EdgeInsets.all(5),
      height:small?25:60,
      child: Row(
        children:[
          small?
            Text(title[0], style: TextStyle(fontSize:14))
            :Text(title, style: TextStyle(fontSize:20)),
          Expanded(
            child:LinearPercentIndicator(
              animation: true,
              lineHeight: small?10.0:20.0,
              percent: value,
              trailing: small?
                Text(
                "${((value*100).round())}%",
                style: TextStyle(fontSize:12),
                ):
                Text(
                  "${((value*10000).round()/100)}%",
                  style: TextStyle(fontSize:15),
                ),
              // center: small?
              //   Text(
              //     "${((value*100).round())}",
              //     style: TextStyle(fontSize:5),
              //   ):null,
              linearStrokeCap: LinearStrokeCap.roundAll,
              backgroundColor: Colors.grey[300],
              progressColor: Color.alphaBlend(
                COLOR_RED.withAlpha((value*255).round()),
                COLOR_GREEN.withAlpha(255-(value*255).round()),
              ),
            ),
          )
        ]
      )
    );
  }
}



class SmallModelAspects extends StatefulWidget {
  String stockID;
  SmallModelAspects({Key? key, required this.stockID}) : super(key: key);

  @override
  _SmallModelAspectsState createState() => _SmallModelAspectsState();
}

class _SmallModelAspectsState extends State<SmallModelAspects> {
  @override

  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return FutureBuilder<List<dynamic> >(
      future: getStockPrediction(stockID:widget.stockID),
      builder: (context,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child:CircularProgressIndicator());
        }else if (snapshot.hasError) {
          print (snapshot.error);
          return Container(child:Center(child:Text("API Error Occurred")));
        }else{
          Map<dynamic, dynamic> nowInfo = snapshot.data!.last;
          if (nowInfo['y_agg']<0.0) {
            nowInfo = snapshot.data![snapshot.data!.length-2];
          }
          // if (nowInfo)
          return Container(
            // height:120,
            // width: 200,
            // color: themeData.primaryColorLight,
            margin:EdgeInsets.only(top:15, left:7, right:7,bottom:5),
            decoration: BoxDecoration(
              border: Border.all(
                color: COLOR_GREY,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(10),
              color: COLOR_WHITE,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 4,
                  blurRadius: 4,
                  offset: Offset(2,4),
                )
              ],
            ),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Expanded(
                    child:Container(
                      color: nowInfo['y_agg']>0.5?COLOR_RED:COLOR_GREEN,
                      padding: EdgeInsets.all(5),
                      child:FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text("模型綜合評分: ${(nowInfo['y_agg']*10000).round()/100}",
                          style: TextStyle(color:COLOR_WHITE, fontWeight: FontWeight.w600,
                            fontSize:23,
                          ),
                        ),
                      )
                    ),
                  ),
                  Row(children:[
                    Expanded(child:Column(children:[
                      ModelAspectBar("基本面", nowInfo['y_f']), // fundamental
                      ModelAspectBar("趨勢面", nowInfo['y_tt']), // tech trend
                      ModelAspectBar("動能面", nowInfo['y_m']),
                    ])),
                    Expanded(child:Column(children:[
                      ModelAspectBar("籌碼面", nowInfo['y_t']),
                      ModelAspectBar("總經面", nowInfo['y_ma']),
                      ModelAspectBar("情緒面", nowInfo['y_nlp']),
                    ])),
                  ]),
            ]

            )
          );
        }
      }
    );
  }
}

class RiskRadarChart extends StatelessWidget {
  String stockID;
  RiskRadarChart({required this.stockID, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<dynamic, dynamic> >(
      future: getStockRiskRank(stockID: stockID),
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("Loading...");
      }else if (snapshot.hasError) {
        return Container();
      }else{
        Map<dynamic, dynamic> rr = snapshot.data!['risk_rank'];
        return Container(
          // height:120,
          decoration: BoxDecoration(
            border: Border.all(
              color: COLOR_GREY,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(3),
            color: COLOR_WHITE,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 4,
                blurRadius: 4,
                offset: Offset(2,4),
              )
            ],
          ),
          child:Column(children:[
            Container(
              color: COLOR_BLUE,
              child: Text("風險評量",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: COLOR_WHITE,
                )
              ),
            ),
            Expanded(
              child:RadarChart.light(
                ticks: [1,2,3,4,5],
                features:["Alpha", "Beta", "波動度","模型性能","財務信評"],
                data:[
                  [
                    rr["alpha_rank"],
                    rr["beta_rank"],
                    3,3,3,
                  ]
                ],
              )
            )
          ]
          )
        );
      }
    });
  }
}


class BigValueChart extends StatefulWidget {
  final String stock;
  bool singleStock;
  String title;
  String initGraph;
  BigValueChart({Key? key, required this.stock,
    this.singleStock = true, this.title='Error', this.initGraph='即時'}) : super(key: key);

  @override
  _BigValueChartState createState() => _BigValueChartState();
}

class FunctionPage{
  String title;
  int group;
  IconData icon;
  FunctionPage( this.title, this.icon, this.group);
}

class StockBar extends StatelessWidget {
  String title;
  int stockID;
  bool singleStock;
  StockBar({Key? key, required this.title, required this.stockID, this.singleStock = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children:[
          Text(title, style: themeData.textTheme.headline2!.copyWith(
            fontSize:40,
          )),
          stockID!=-1? Text(stockID.toString(), style: themeData.textTheme.subtitle1!.copyWith(
            fontSize:22,
          )):Container(),
          Expanded(child:Container()),
          FutureBuilder<Map<dynamic, dynamic> >(
              future: getStockRealtime(singleStock: singleStock, stockID: stockID.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading...");
                }else if (snapshot.hasError) {
                  return Container();
                }else{
                  final mC = snapshot.data!['chartMarketChange'];
                  final mCP = snapshot.data!['chartMarketChangePercent'];
                  final cMP = snapshot.data!['chartMarketPrice'];
                  final dir = mC==0?0:mC/(mC.abs());
                  late var toColor;
                  late IconData arrow;
                  switch (dir) {
                    case -1:
                      toColor = COLOR_GREEN;
                      arrow = Icons.arrow_circle_down_sharp;
                      break;
                    case 0:
                      toColor = COLOR_DARK_GREY;
                      arrow = Icons.remove_circle_outline_sharp;
                      break;
                    case 1:
                      toColor = COLOR_RED;
                      arrow = Icons.arrow_circle_up_sharp;
                      break;
                  }
                  return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          arrow,
                          color: toColor,
                        ),
                        Text(" $cMP",style: themeData.textTheme.headline4!.copyWith(
                            fontWeight:FontWeight.w500, color: toColor, height:1.0)),
                        Text(" $mC (${mCP}%)", style: themeData.textTheme.headline4!.copyWith(
                            fontSize: 14, color: toColor, height:1.0)),
                      ]);
                }
              }
          ),
        ]
    );
  }
}


class _BigValueChartState extends State<BigValueChart> {
  @override
  Graph child = Graph("Empty", Container(),5);
  List<List<Graph> > graphs = [[],[],[],[],[]];
  List<FunctionPage> pageNames = [
    FunctionPage('技術',Icons.multiline_chart_sharp,1),
    FunctionPage('模型',Icons.model_training_sharp,1),
    FunctionPage('財務',Icons.attach_money_sharp,1),
    FunctionPage('籌碼',Icons.circle,1),
    FunctionPage('其他',Icons.miscellaneous_services_sharp,1),
  ];
  int stockID = -1;
  int currentPage = 1;

  void newGraph(String title, Widget wid, int group, {bool squeeze = false}){
    graphs[group-1].add(Graph(title,wid,group,squeeze:squeeze));
    if (title == widget.initGraph) {
      child = Graph(title, wid,group,squeeze:squeeze);
      currentPage = group;
    }
  }

  initState(){
    if (widget.singleStock) {
      stockID = int.parse(widget.stock);
      widget.title = nameOfID(stockID);
    }else{

    }

    newGraph(
      'K線',
      MyHomePage(title: 'yo', stockID: stockID),
      1,
    );
    newGraph(
      '即時',
      SmallStockDisplay(title:'', initDisplayType: 1, singleStock: widget.singleStock, stockID: widget.stock),
      1,
    );
    if (widget.singleStock) {
      newGraph(
        '新聞',
        BigNewsDisplay(stockID: [stockID]),
        5,
      );

      newGraph(
        '法人持股',
        Container(
          height: 400,
          child: InstInvHoldings(stockID: int.parse(widget.stock), diff: false, key:GlobalKey()),
        ),
        4
      );

      newGraph(
        '法買賣超',
        Container(
          height: 400,
          child: InstInvHoldings(stockID: int.parse(widget.stock), diff: true, key:GlobalKey()),
        ),
        4
      );

      newGraph(
        '營業財務',
        Container(
          height: 400,
          child: QuarterlyChart(stockID: stockID.toString()),
        ),
        3
      );

      newGraph(
        '模型效能',
        Container(
          height: 400,
          child: ModelMonitor(stockID: stockID.toString()),
        ),
        2
      );

      newGraph(
        '多空標注',
        Container(
          height: 450,
          child: PredictionChart(stock: stockID.toString()),
        ),
        2,
        squeeze:true,
      );
    }
    // newGraph(
    //   '模型預測',
    //   Container(
    //     height: 400,
    //     child: PredictionChart(stock: widget.stock),
    //   )
    // );
    newGraph(
      '風險評量',
      Container(
        height: 400,
        child: RiskRadarChart(stockID: widget.stock),
      ),
      2
    );


  }

  Widget MyButton(Graph g) {
    return Button(
      key: ValueKey('${g.title}'),
      onPressed: (){
        setState(
          (){
            child=g;
          }
        );
      },
      selected: g.title == child.title,
      title: g.title,
    );
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print ("Width: ${size.width}, H: ${size.height}");
    final ThemeData themeData = Theme.of(context);
    return OrientationBuilder(
      builder: (context, orientation) {
        Widget renderedChild = !child.squeeze || orientation == Orientation.portrait? child.widget:
          ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: size.height - 50,
              ),
              child: child.widget
          );
        return Scaffold(
          appBar: orientation == Orientation.portrait? TopBar(title: child.title+'模式', subPage: true) : null,
          backgroundColor: themeData.backgroundColor,
          body: Container(
            padding: EdgeInsets.only(top: 5, left: 5, right:5),
            child: ListView(
              shrinkWrap: true,
              children: [

                StockBar(title:widget.title, stockID:stockID, singleStock: widget.singleStock),

                currentPage == 2?Container(
                  height:170,
                  child: Row(children:[
                    Expanded(
                      flex: 2,
                      child: SmallModelAspects(stockID:stockID.toString()),
                    ),
                    // Expanded(
                    //   flex: 1,
                    //   child: RiskRadarChart(stockID:stockID.toString()),
                    // )
                  ]
                  ),
                ):Container(),
                Container(
                  height: 70,
                  width: double.infinity,
                  color: themeData.backgroundColor,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < graphs[currentPage-1].length; i++)
                          Container(
                            width: 100,
                            padding:
                            const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: MyButton(graphs[currentPage-1][i]),
                          ),
                      ],
                    ),
                  ),
                ),
                renderedChild,
              ],
            ),
          ),

          bottomNavigationBar: orientation == Orientation.portrait? BottomNavigationBar(
            items: pageNames.map(
                    (e) => (
                    BottomNavigationBarItem(
                      icon: Icon(e.icon),
                      label: e.title,
                    )
                )
            ).toList(),
            currentIndex: currentPage-1,
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: COLOR_BLUE,
            showUnselectedLabels: true,
            onTap: (which){
              if (currentPage != which+1) {
                currentPage = which+1;
                child = graphs[currentPage-1][0];
                setState((){});
              }
            },
          ) : null,
        );
      }
    );
  }
}




class Graph{
  String title;
  Widget widget;
  int group;
  bool squeeze;
  Graph( this.title, this.widget, this.group, {this.squeeze=false});
}
