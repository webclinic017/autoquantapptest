import 'package:flutter/material.dart';
import 'smallStockDisplay.dart';

class StockGroups extends StatefulWidget {
  @override
  _StockGroupsState createState() => _StockGroupsState();
}

class _StockGroupsState extends State<StockGroups> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  List<StockGroupDisplay> groups = [
    StockGroupDisplay.fromList([2330,2330]),
    StockGroupDisplay.fromList([2330,2330,2330]),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: PageView(
        controller: _controller,
        children: groups,
      )
    );

  }
}

class StockGroupDisplay extends StatefulWidget {
  late List<SmallStockDisplay> stocks;
  StockGroupDisplay({Key? key, required this.stocks}) : super(key: key);

  @override
  StockGroupDisplay.fromList(List<int> stockIDs) {
    this.stocks = stockIDs.map(
          (stockID) => SmallStockDisplay(title: 'hi', stockID: stockID)
      ).toList();
  }

  @override
  _StockGroupDisplayState createState() => _StockGroupDisplayState();
}

class _StockGroupDisplayState extends State<StockGroupDisplay> {
  @override

  bool editMode = false;
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: widget.stocks,
      ),
    );
  }
}
