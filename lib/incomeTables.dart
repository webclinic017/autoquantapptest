import 'package:flutter/material.dart';
import 'utils/getAllStocks.dart';


class QuarterlyChart extends StatelessWidget {
  String stockID;
  QuarterlyChart({Key? key, required this.stockID}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<dynamic> >(
      future: getStockIncomeStatement(stockID:stockID),
      builder: (context,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Container(child: Center(child: Text("API Error Occurred")));
        } else {
          return DataTable(
            columns: [
              DataColumn(
                label: Text('年季'),
              ),
              DataColumn(
                label: Text('收入淨額'),
              ),
              DataColumn(
                label: Text('成本'),
              ),
              DataColumn(
                label: Text('毛利'),
              ),
              DataColumn(
                label: Text('費用'),
              ),
            ],
            rows: snapshot.data!.map<DataRow>(
                (lst) => DataRow(
                cells: [
                  DataCell(Text(lst['年季'].toString())),
                  DataCell(Text(lst['營業收入淨額(千)'].toString())),
                  DataCell(Text(lst['營業成本(千)'].toString())),
                  DataCell(Text(lst['營業毛利(千)'].toString())),
                  DataCell(Text(lst['營業費用(千)'].toString())),
                ]
            )
            ).toList(),
          );
        }
      }
    );
  }
}

class ModelMonitor extends StatelessWidget {
  String stockID;
  ModelMonitor({Key? key, required this.stockID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    List<DataRowInfo> dri = [
      DataRowInfo('現股 Sharpe','ratios','Sharpe'),
      DataRowInfo('模型 Sharpe','ratios_pred','Sharpe'),
      DataRowInfo('模型 IR','ratios_pred','Info'),
    ];
    return FutureBuilder<Map<dynamic, dynamic> >(
        future: getModelMonitor(stockID:stockID),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Container(child: Center(child: Text("API Error Occurred")));
          } else {
            Map<dynamic, dynamic> mp = snapshot.data!;
            return Column(
              children:[
                Text("模型勝率: ${mp['wl_ratio']['win_rate']}", style: themeData.textTheme.headline3),
                DataTable(
                  columns: [
                    DataColumn(
                      label: Text(''),
                    ),
                    DataColumn(
                      label: Text('近1月'),
                    ),
                    DataColumn(
                      label: Text('近3月'),
                    ),
                    DataColumn(
                      label: Text('近6月'),
                    ),
                    DataColumn(
                      label: Text('近1年'),
                    ),
                  ],
                  rows:dri.map((e)=>DataRow(
                    cells:
                      [1,3,6,12].map((num) => DataCell(
                        Text(((100*mp[e.where][e.type + "_" + num.toString()+ "M"]).round()/100).toString()),
                      )).toList()..insert(0, DataCell(Text(e.title))),
                  )).toList(),
                )

              ]
            );
          }
        }
    );
  }
}

class DataRowInfo{
  String title, where, type;
  DataRowInfo(this.title, this.where, this.type);
}
