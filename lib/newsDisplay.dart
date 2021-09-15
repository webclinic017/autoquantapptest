import 'package:flutter/material.dart';
import 'utils/newsInfo.dart';
import 'utils/getNews.dart';
import 'dart:math';
import 'utils/constants.dart';
import 'newsElement.dart';


class BigNewsDisplay extends StatefulWidget {
  List<int> stockID;
  BigNewsDisplay({Key? key, required this.stockID}) : super(key: key);

  @override
  _BigNewsDisplayState createState() => _BigNewsDisplayState();
}

class _BigNewsDisplayState extends State<BigNewsDisplay> {
  @override
  int numDisplay = 20;

  Future<List<NewsInfo> >? newsInfo;

  void updateNews(){
    newsInfo = getNews(widget.stockID);
  }

  void initState(){
    super.initState();
    updateNews();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsInfo> > (
        future: newsInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List <Widget> children = [];
            // print(snapshot.data!.length);
            for (int i = 0; i<min(numDisplay, snapshot.data!.length); ++i) {
              children.add(Card(
                  shadowColor: COLOR_GREY,
                  elevation: 7,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical:10,),
                    child: NewsElement(
                      lineLimit: 6,
                      title: snapshot.data![i].title,
                      time: snapshot.data![i].dateTime.toString(),
                      text: snapshot.data![i].text,
                    ),
                  )
              ));
              children.add(
                Container(height:10),
              );
            }

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

  }
}