import 'package:flutter/material.dart';

class NewsElement extends StatefulWidget {
  final String time;
  final String text;

  const NewsElement({Key? key, required this.time, required this.text}) : super(key: key);

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
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget> [
            Text(widget.time, style: themeData.textTheme.subtitle1),
            Text(widget.text,
              style: themeData.textTheme.headline2,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              softWrap: false,
            ),
          ],
        ),
    );
  }
}
