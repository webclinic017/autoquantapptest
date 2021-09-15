import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testproject1/treemapPage.dart';
import 'valueChart.dart';
import 'utils/constants.dart';
import 'dashboardNewsDisplay.dart';
import 'displayContainer.dart';
import 'bigValuePage.dart';
import 'dailyChart.dart';
import 'realTimeChart.dart';
import 'stockGroups.dart';
import 'treemapPage.dart';
import 'topBar.dart';
import 'navigationDrawer.dart';
import 'stockScreenPage.dart';
import 'bigValuePage.dart';
import 'utils/stockSearchDelegate.dart';
import 'newsDisplay.dart';
import 'marketScoreChart.dart';

class GeneralStatsBar extends StatelessWidget {
  const GeneralStatsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container (
      height: 350.0,
      width: 800.0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(right:45, left:2, top: 15, bottom:15),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Container(
              height: 350, width : 350,
              child: MarketScoreChart(),
            ),
            // MarketScoreChart(),
            DisplayContainer(
              title:'加權指數即時',
              element: Expanded(child:RealTimeChart(stockID: 'TWS:TSE01', singleStock: false)),
              route: BigValueChart(
                stock:'TWS:TSE01',
                singleStock: false,
                title: '加權指數',
              ),
            ),
            DisplayContainer(
              title:'櫃買指數即時',
              element: Expanded(child:RealTimeChart(stockID: 'TWS:OTC01', singleStock: false)),
              route: BigValueChart(
                stock:'TWS:OTC01',
                singleStock: false,
                title: '櫃買指數',
              ),
            ),

          ],

        )

      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class IndividualStocksPage extends StatelessWidget {
  const IndividualStocksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children:[
      Container(
        height:50,
        width: 100,
        child: Card(
          elevation: 10,
          color: COLOR_WHITE,
          shadowColor: COLOR_DARK_GREY,
          child: InkWell(
            onTap: (){
              Future<int?> newStockID = showSearch(
                context: context,
                delegate: StockSearchDelegate(),
              );
              newStockID.then(
                (int? value) {
                  print ("Got value back");
                  if (value!=null && value >= 0){
                    print ("going to navigate to $value");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BigValueChart(stock: value.toString(), initGraph: 'K線')));

                  }
                }
              );

            },
            child: Row(children:[
              Text("搜尋個股"),
              Expanded(child: Container()),
              Icon(Icons.search),
            ])
          )
        )
      ),
      Text('我的關注個股', style: MAIN_TEXT_THEME.headline1),
      StockGroups(),
    ]);
  }
}


class _DashboardState extends State<Dashboard> {
  @override
  List<Widget> pages = [

  ];
  int currentPage = 0;
  initState(){
    pages.add(IndividualStocksPage());
    pages.add(
      ListView(children:[
        Text('大盤資訊', style: MAIN_TEXT_THEME.headline1),
        GeneralStatsBar(),
      ])
    );
    pages.add(
      ListView(children:[
        Text('產業類股與多空股', style: MAIN_TEXT_THEME.headline1),
        TreeMapChart(type:'TSE'),
      ])
    );
    pages.add(
        ListView(children:[
          Text('多空選股', style: MAIN_TEXT_THEME.headline1),
          StockScreener(),
        ])
    );
    pages.add(
        ListView(children:[
          Text('市場新聞與消息動態', style: MAIN_TEXT_THEME.headline1),
          BigNewsDisplay(stockID:[2330, 2450]),
        ])
    );
  }
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      // color: COLOR_VERY_LIGHT_GREY,
        appBar: TopBar(),
        drawer: NavigationDrawer(),
        body: Container(
          child: pages[currentPage],
          padding: EdgeInsets.all(5),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart_sharp),
              label: '自選各股',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.multiline_chart_sharp),
              label: '大盤',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.corporate_fare_sharp),
              label: '產業多空',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radar_sharp),
              label: '選股',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.new_releases_sharp),
              label: '新聞',
            ),
          ],
          currentIndex: currentPage,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: COLOR_BLUE,
          showUnselectedLabels: true,
          onTap: (which){
            if (currentPage != which) {
              currentPage = which;
              setState((){});
            }
          },
        ),
    );
  }
}
