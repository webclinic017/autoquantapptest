import 'package:flutter/material.dart';
import 'package:testproject1/bigValueChart.dart';
import 'dart:math';
import 'utils/constants.dart';

class DisplayContainer extends StatefulWidget {
  int duration = 0;
  final Widget element;
  Widget? route = null;
  String title;
  double width;
  double? height;

  DisplayContainer ({Key? key, required this.title, required this.element,
    this.route, this.width = 350, this.height}) : super(key: key);

  @override
  _DisplayContainerState createState() => _DisplayContainerState();
}

class _DisplayContainerState extends State<DisplayContainer> with TickerProviderStateMixin {
  @override


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);

    return GestureDetector(
        onTap: (){
          if (widget.route != null) {
            // print('hello');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget.route!),
            );
          }
        },
        child: AnimatedSize(
            curve: Curves.linear,
            vsync: this,
            duration: const Duration(milliseconds:200),
            child: Container (
                width: widget.width,
                height: widget.height,

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
                    Text(widget.title, style: themeData.textTheme.headline3),
                    Divider(
                      height: 7,
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    ),
                    widget.element,
                  ],
                )
            )
        )
    );
  }
}
