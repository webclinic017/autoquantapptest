import 'package:flutter/material.dart';
import 'utils/news_data.dart';
import 'dart:math';
import 'newsElement.dart';
import 'displayContainer.dart';
import 'utils/newsInfo.dart';
import 'utils/getNews.dart';

class DashboardNewsDisplay extends StatefulWidget {
  const DashboardNewsDisplay({Key? key}) : super(key: key);

  @override
  _DashboardNewsDisplayState createState() => _DashboardNewsDisplayState();
}

class _DashboardNewsDisplayState extends State<DashboardNewsDisplay> {
  @override
  int numDisplay = 2;

  Future<List<NewsInfo> >? newsInfo;

  void updateNews(){
    newsInfo = getNews([2330]);
  }

  void initState(){
    super.initState();
    updateNews();
  }

  Widget build(BuildContext context) {
    var element = FutureBuilder<List<NewsInfo> > (
      future: newsInfo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          List <Widget> children = [];
          for (int i = 0; i<min(numDisplay, snapshot.data!.length); ++i) {
            children.add(NewsElement(
              lineLimit: 3,
              title: snapshot.data![i].title,
              time: snapshot.data![i].dateTime.toString(),
              text: snapshot.data![i].text,
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
                          numDisplay += 3;
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
                    IconButton(
                        icon: Icon(Icons.refresh_sharp),
                        onPressed: (){
                          setState((){
                            newsInfo=getNews([2330]);
                          });
                        }
                    ),
                  ],
              )
            )
          );
          return Column(
            children: children,
          );
        }else if (snapshot.hasError) {
          return Text('oh no ${snapshot.error}');
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
    return DisplayContainer(
        title: '市場新聞與消息動態',
        element: element,
    );
  }
}


