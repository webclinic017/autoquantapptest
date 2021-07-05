import 'package:flutter/material.dart';
import 'package:testproject1/bigValueChart.dart';
import 'dart:math';
import 'utils/constants.dart';


class DisplayContainer extends StatelessWidget {
  int duration = 0;
  final Widget element;
  Widget? route = null;
  String title;
  double setWidth = 350;
  double setHeight = double.infinity;

  DisplayContainer ({Key? key, required this.title, required this.element, this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);

    return GestureDetector(
      onTap: (){
        if (route != null) {
          // print('hello');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route!),
          );
        }
      },
      child: Container (
        width: setWidth,
        height: setHeight,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: COLOR_GREY,
          ),
          borderRadius: BorderRadius.circular(10),
          color: COLOR_WHITE,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(2,5),
            )
          ],
        ),


        child: Column(
          children: <Widget> [
            Text(title, style: themeData.textTheme.headline3),
            Divider(
              height: 5,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: element,
            ),
          ],
        )
      )
    );
  }
}
