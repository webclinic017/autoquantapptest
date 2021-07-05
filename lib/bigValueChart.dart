import 'package:flutter/material.dart';


class BigValueChart extends StatefulWidget {
  final String imageFile;
  final String title;

  const BigValueChart({Key? key, required this.title, required this.imageFile}) : super(key: key);

  @override
  _BigValueChartState createState() => _BigValueChartState();
}

class _BigValueChartState extends State<BigValueChart> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    return Container(
      color: themeData.backgroundColor,
      child: Column(
        children: <Widget> [
          Hero(
            tag: 'tempImageHero',
            child: Image.asset(widget.imageFile),
          ),
          Text(widget.title,style: themeData.textTheme.headline2),
          Text('blah blah blah',style: themeData.textTheme.bodyText2),
          Text('123455678910',style: themeData.textTheme.bodyText2),
          Text('blah blah blah blah blah blah blah',style: themeData.textTheme.bodyText2),
        ],
      ),

    );
  }
}

