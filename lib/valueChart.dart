import 'package:flutter/material.dart';
import 'dart:math';
import 'utils/constants.dart';

class ValueChart extends StatefulWidget {
  final String imageFile;

  const ValueChart({Key? key, required this.imageFile}) : super(key: key);

  @override
  _ValueChartState createState() => _ValueChartState();
}

class _ValueChartState extends State<ValueChart> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    return Expanded(child:Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget> [
          Row(
            children: <Widget> [
              Text((new Random()).nextInt(10000000).toString(),
                style: themeData.textTheme.bodyText1,
              ),
              Expanded(
                child: Container(),
              ),
              Text(((new Random()).nextInt(100)-50).toString(),
                style: themeData.textTheme.bodyText1,
              ),

            ],
          ),
          Expanded(
            child: Hero(
              tag: 'tempImageHero',
              child:
                Image.asset(widget.imageFile),
              ),
          )
        ],
      )

    ));
  }
}
