import 'package:flutter/material.dart';
import 'utils/news_data.dart';
import 'dart:math';
import 'newsElement.dart';
import 'displayContainer.dart';


class DashboardNewsDisplay extends StatefulWidget {
  const DashboardNewsDisplay({Key? key}) : super(key: key);

  @override
  _DashboardNewsDisplayState createState() => _DashboardNewsDisplayState();
}

class _DashboardNewsDisplayState extends State<DashboardNewsDisplay> {
  @override
  int numDisplay = 2;
  Widget build(BuildContext context) {
    List <Widget> children = [];
    for (int i = 0; i<min(numDisplay, NEWS_DATA.length); ++i) {
      children.add(NewsElement(
        lineLimit: 3,
        title: NEWS_DATA[i]['title']!,
        time: NEWS_DATA[i]['time']!,
        text: NEWS_DATA[i]['text']!,
      ));
      children.add(Divider(
        height: 10,
        thickness: 2,
        indent: 40,
        endIndent: 40,
      ));
    }
    children.add(
      Card(
        child:
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.unfold_more_sharp),
                onPressed: (){
                  setState((){
                    print(numDisplay);
                    numDisplay += 2;
                  });
                }
              ),
              IconButton(
                icon: Icon(Icons.expand_less_sharp),
                onPressed: (){
                  setState((){
                    print(numDisplay);
                    numDisplay = 2;
                  });
                }
              ),
            ],
        )
      )
    );
    return DisplayContainer(
        title: '市場新聞與消息動態',

        element: Column(
          children: children,
        )
    );
  }
}


