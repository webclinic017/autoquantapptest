import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'realTimeChart.dart';

class SmallStockDisplay extends StatefulWidget {
  int duration = 0;
  Widget? route = null;
  String title;
  int stockID;
  double width;
  double height;

  SmallStockDisplay ({Key? key, required this.title, required this.stockID,
    this.route, this.width = 185, this.height=200}) : super(key: key);

  @override
  _SmallStockDisplayState createState() => _SmallStockDisplayState();
}

class _SmallStockDisplayState extends State<SmallStockDisplay> with TickerProviderStateMixin {
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
                  // border: Border.all(
                  //   color: COLOR_GREY,
                  // ),
                  borderRadius: BorderRadius.circular(3),
                  color: COLOR_WHITE,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 6,
                      offset: Offset(2,5),
                    )
                  ],
                ),


                child: Column(
                  children: <Widget> [
                    Center( child: Text(
                        "${widget.title} ${widget.stockID}",
                        style: themeData.textTheme.headline4,
                    )),

                    RealTimeChart(stockID: widget.stockID),
                  ],
                )
            )
        )
    );
  }
}
