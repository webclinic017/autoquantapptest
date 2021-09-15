import 'package:flutter/material.dart';
import 'topBar.dart';
import 'package:flutter/gestures.dart';
import 'bigValuePage.dart';

class NewsElement extends StatefulWidget {
  final String title;
  final String time;
  final String text;
  int? lineLimit;
  NewsElement({Key? key, required this.time, required this.text,
    required this.title, this.lineLimit}) : super(key: key);

  @override
  _NewsElementState createState() => _NewsElementState();
}

class _NewsElementState extends State<NewsElement> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FullNewsDisplay(
              title:widget.title,
              time:widget.time,
              text:widget.text,
            )),
          );
        },
        child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget> [
            Text(widget.title,
              style: themeData.textTheme.headline5,
              overflow: TextOverflow.ellipsis,
              maxLines: widget.lineLimit??60,
              softWrap: false,
            ),
            Text(widget.time, style: themeData.textTheme.subtitle1),
            Text(widget.text,
              style: themeData.textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
              maxLines: widget.lineLimit??60,
              softWrap: false,
            ),
          ],
        ),
    ));
  }
}

class FullNewsDisplay extends StatefulWidget {
  final String title;
  final String time;
  final String text;

  FullNewsDisplay({Key? key, required this.time, required this.text,
    required this.title}) : super(key: key);
  @override
  _FullNewsDisplayState createState() => _FullNewsDisplayState();
}

class _FullNewsDisplayState extends State<FullNewsDisplay> {
  @override
  bool favorite = false;
  List<String> sentences = [""];
  List<RichText> para = [];
  int fontSize = 18;
  initState(){
    List<String> temp = widget.text.split("。");

    int threshold = 200;
    for (String s in temp) {
      if (s == "") continue;
      s += "。";
      if (sentences.last.length+s.length < threshold) {
        sentences.last += s;
      }else{
        sentences.add(s);
      }
    }
    if (sentences.last == "") {
      sentences.removeLast();
    }

  }

  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar:TopBar(title: '新聞查考', subPage: true),

      body: Container(
        padding: EdgeInsets.only(left: 10, right:10, top: 10),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Text(widget.title, style: themeData.textTheme.headline3),
            Row(
              children: [
                Text(
                  widget.time, style: themeData.textTheme.subtitle1,
                ),
                Expanded(child:Container()),
                IconButton(
                    icon: Icon(Icons.keyboard_arrow_down_sharp),
                    onPressed: (){
                      setState((){
                        if (fontSize > 1)
                          fontSize--;
                      });
                    }
                ),
                Icon(
                  Icons.font_download_outlined,
                ),
                Text(
                  ": ${fontSize}",
                  style: themeData.textTheme.bodyText1,
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_up_sharp),
                  onPressed: (){
                    setState((){
                      if (fontSize < 50)
                        fontSize++;
                    });
                  }
                ),
                IconButton(
                  icon: Icon(favorite? Icons.star_sharp :
                                       Icons.star_border_sharp),
                  onPressed: (){
                    setState((){
                      favorite = !favorite;
                    });
                  }
                ),

              ]
            ),
            Container(
              height:10,
            ),
            Column(
              children:
                sentences.map<Widget>(
                  (s) {
                    final style = themeData.textTheme.bodyText1!.copyWith(
                        fontSize: fontSize.toDouble());
                    List<TextSpan> tsp = [];
                    for (int i = 0; i<s.length; ++i) {
                      tsp.add(TextSpan(text:s[i], style: style));
                      if (i-5 >= 0) {
                        String ty = s.substring(i-5,i+1);
                        if (ty[0] == '（' && ty[5] == '）') {
                          print ("tyty $ty");
                          int? stockID = int.tryParse(ty.substring(1,5));
                          if (stockID != null && stockID >= 1000 && stockID <= 9999) {
                            for (int j = 0; j<6; ++j) tsp.removeLast();
                            tsp.add(TextSpan(text:ty, style: style.copyWith(color: Colors.blue[400]),
                                recognizer : TapGestureRecognizer()..onTap = (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BigValueChart(stock: stockID.toString(), initGraph: 'K線')));
                                }
                            ));
                          }
                        }
                      }
                    }

                    return Container(
                      padding: EdgeInsets.only(bottom:12),
                      child:RichText(
                        text: TextSpan(
                          children: tsp,
                        ),
                      ),
                    );
                  }
                ).toList(),

            ),
          ],
        ),
    ));
  }
}

/*

 */
