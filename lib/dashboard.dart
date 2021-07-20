import 'package:flutter/material.dart';
import 'valueChart.dart';
import 'utils/constants.dart';
import 'dashboardNewsDisplay.dart';
import 'displayContainer.dart';
import 'bigValueChart.dart';
import 'dailyChart.dart';
import 'realTimeChart.dart';
import 'stockGroups.dart';

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
            DisplayContainer(
              title:'台積電日線',
              element: DailyChart(stockID: 2330),
              route: BigValueChart(
                title:'投資組合績效',
                imageFile:'assets/tempPortfolioImage.png'),
            ),
            DisplayContainer(
              title: ":D",
              element: RealTimeChart(stockID: 2330),
              route: BigValueChart(
                  title:'投資組合績效',
                  imageFile:'assets/tempPortfolioImage.png'),
            ),
            DisplayContainer(
              title:'聯發科日線',
              element: DailyChart(stockID: 2454),
              route: BigValueChart(
                  title:'投資組合績效',
                  imageFile:'assets/tempPortfolioImage.png'),
            ),
            DisplayContainer(
              title:'臺灣加權股價指數',
              element: ValueChart(imageFile:'assets/tempTPEX.png'),
              route: BigValueChart(
                  title:'臺灣加權股價指數',
                  imageFile:'assets/tempTPEX.png'),
            ),
          ],

        )

      ),
    );
  }
}



class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.only(left:15, right:5, top:10),
      children: <Widget>[
        Text('My Dashboard', style: themeData.textTheme.headline1),
        GeneralStatsBar(),

        StockGroups(),
        DashboardNewsDisplay(),
        // Text('市場新聞與消息動態', style: themeData.textTheme.headline2, textAlign: TextAlign.center),
        // Text('And so they lived happily ever after', style: themeData.textTheme.subtitle1),
      ],
    );
  }
}

