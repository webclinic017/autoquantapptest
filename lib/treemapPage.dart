import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_treemap/treemap.dart';
import 'utils/getIP.dart';
import 'dart:convert';
import 'dart:math';
import 'bigValuePage.dart';
import 'button.dart';
import 'topBar.dart';

class getTreemap extends StatelessWidget {

  late List<StockTile> source;
  late List<TreemapColorMapper> _colorMappers;
  bool smoothSize = false;
  getTreemap({this.smoothSize=false, required this.source, required Key key}) : super(key: key);



  @override
  Widget build(BuildContext context){
    _colorMappers = <TreemapColorMapper>[
      TreemapColorMapper.range(
          from: 0,
          to: 0.5,
          minSaturation: 0,
          maxSaturation: 1,
          color: Colors.green[400]!),
      TreemapColorMapper.range(
          from: 0.5,
          to: 1,
          minSaturation: 0,
          maxSaturation: 1,
          color: Colors.red[400]!),
    ];
    return SfTreemap(
      dataCount: source.length,
      weightValueMapper: (int index) {
        if (smoothSize) return 1.0/source[index].peers + log(source[index].value)/100;
        return source[index].value;
      },
      onSelectionChanged: (TreemapTile tile) {
        print ("Yo ${tile.level}");
        if (!tile.hasDescendants) {
          String name = source[tile.indices[0]].name;
          String number = "";
          for (int i = 0; i<name.length; ++i ) {
            if (int.tryParse(name[i]) != null) {
              number += name[i];
            }
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BigValueChart(stock:number)));
        }else{
          assert(false);
          print ("Group is ${tile.group}");
        }
      },
      selectionSettings: TreemapSelectionSettings(

      ),
      enableDrilldown: true,

      breadcrumbs: TreemapBreadcrumbs(
        builder:
            (BuildContext context, TreemapTile tile, bool isCurrent) {
          if (tile.group == 'Home') {
            return Icon(Icons.home_sharp);
          } else {
            return Text(tile.group,
                style: TextStyle(color: Colors.black));
          }
        },
        divider: Icon(Icons.chevron_right, color: Colors.black),
        position: TreemapBreadcrumbPosition.top,
      ),
      levels: [

        TreemapLevel(
          groupMapper: (int index) => source[index].parent,
          // color: Colors.pink,

          labelBuilder: (BuildContext context, TreemapTile tile) {
            return Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 5.0),
              child: Text(
                tile.group,
                style: TextStyle(color: Colors.black),
                overflow: TextOverflow.fade,
              ),
            );
          },

          colorValueMapper: (TreemapTile tile) {
            double myColor = 0;
            double div = 0;
            for (int i in tile.indices) {
              myColor += source[i].colorValue * source[i].value;
              div += source[i].value;
            }
            return div==0?0.5 : myColor / div;
          },
        ),
        TreemapLevel(
          groupMapper: (int index) {
            return source[index].name;
          },
          colorValueMapper: (TreemapTile tile) {
            return source[tile.indices[0]].colorValue;
          },
          labelBuilder: (BuildContext context, TreemapTile tile) {
            return Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 5.0),
              child: Text(
                tile.group,
                style: TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            );
          },

        ),

      ],
      colorMappers: _colorMappers,
    );
  }
}


class TreeMapChart extends StatefulWidget {
  final String type;
  const TreeMapChart({Key? key, required this.type}) : super(key: key);

  @override
  _TreeMapChartState createState() => _TreeMapChartState();
}

class _TreeMapChartState extends State<TreeMapChart> {
  @override



  bool showLoading = true;
  bool hasError = false;
  bool enlarge = false;
  String type = "TSE";

  bool smooth = false;
  Widget ? childMap = null;

  late List<StockTile> source;

  void getData() {
    setState((){
      showLoading = true;
    });
    final Future<String> future = getIP(
        'https://autoquant.ai/api/v1/sector/treemap/$type');
    future.then((String result) {
      final Map parseJson = json.decode(result) as Map<String, dynamic>;
      final list = parseJson['data'];
      source = [];
      Map<String, int> cnt = {};
      for (Map<String, dynamic> mp in list) {
        if (cnt[mp['parent']] == null) cnt[mp['parent']] = 0;
        cnt[mp['parent']] = cnt[mp['parent']]!+1;
      }
      for (Map<String, dynamic> mp in list) {
        if (mp['id']==null) {
          double colorValue = mp['colorValue'];
          String parName = mp['parent'];
          String newName = "";
          bool add = false;
          for (int i = 0; i<parName.length; ++i) {
            if (add) newName += parName[i];
            if (parName[i] == '-') add = true;
          }
          if (colorValue <=0.5) colorValue = 0.5-colorValue;
          source.add(StockTile(
            name:mp['name'],
            parent:newName,
            className:mp['className'],
            value:mp['value'],
            colorValue: colorValue,
            peers: cnt[mp['parent']]!,
          ));
        }
      }
      showLoading = false;
      updateChild();
    }).catchError((_) {
      showLoading = false;
      hasError = true;
      setState(() {});
      print('Data Error: $_');
    });
  }


  void initState(){
    smooth = true;
    type = widget.type;
    getData();
    super.initState();
  }

  void updateChild(){
    childMap = getTreemap(smoothSize: smooth, source:source, key:UniqueKey());
    setState((){});
  }

  Widget MyButton(String title, String newType) {
    bool isSelected = type == newType;
    return Container(
        width: 90,
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child:Button(
          key: ValueKey('${title}'),
          onPressed: (){
            setState((){
              type = newType;
              getData();
            });
          },
          selected: isSelected,
          title: title,
        )
    );
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);

    // type = widget.type;

    if (showLoading) {
      return Center(
        child:CircularProgressIndicator(),
      );
    }
    return Container(
      height: (enlarge?2:1) * size.height,
      width: size.width-10,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // MyButton('三法人', true, '法人',),
                MyButton('上市產業', 'TSE',),
                MyButton('上櫃產業', 'OTC',),
                // MyButton('細產業別', 'subSector',),
                MyButton('概念股', 'conceptStock',),
              ],
            ),
          ),
          Row(
            children:[
              IconButton(
                icon: Icon(!smooth?Icons.view_comfy_sharp:Icons.view_quilt_sharp),
                onPressed: (){
                  smooth = !smooth;
                  updateChild();
                  // WidgetsBinding.instance!.addPostFrameCallback((_) => setState((){}));
                },
              ),
              ExpandIcon(
                onPressed: (isBig){
                  setState((){
                    enlarge = !enlarge;
                  });
                }
              ),
            ]
          ),
          Expanded(
            child:childMap!,
          ),
        ]
      )
    );
  }
}

class StockTile{
  final String name, parent, className;
  final double value, colorValue;
  final int peers;
  const StockTile({
    required this.name, required this.parent, required this.className, required this.value, required this.colorValue, required this.peers});
}

class TreemapPage extends StatelessWidget {
  const TreemapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar:TopBar(title: '產業類股多空', subPage: true),
      body:Container(
        padding: EdgeInsets.only(left:5, right:5, top:15),
        child: SingleChildScrollView(
          child: TreeMapChart(type:'TSE'),
        ),
      )
    );
  }
}
