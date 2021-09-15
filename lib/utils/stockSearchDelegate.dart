import 'package:flutter/material.dart';
import 'getAllStocks.dart';


class StockSearchDelegate extends SearchDelegate<int > {

  @override
  List<Widget> buildActions(BuildContext context) {
    return[
      IconButton(
        icon: Icon(Icons.clear_sharp),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_sharp),
      onPressed: () {
        close(context,-1);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> displayString = getStockList().map<String>(
          (e) => "${e['股票代號']} ${e['股票名稱']} ${e['產業名稱']} ${e['指數彙編分類']}",
    ).toList();
    final results =
        displayString.where((e) => e.contains(query));
    return ListView(
      children:results.map<Widget>((e) => ListTile(
        title: Text(e),
        leading: Icon(
          ((){
            if (e.contains('電')) {
              return Icons.lightbulb_sharp;
            }else if (e.contains('金')) {
              return Icons.attach_money_sharp;
            }else if (e.contains('其他')) {
              return Icons.miscellaneous_services_sharp;
            }else if (e.contains('運')) {
              return Icons.home_repair_service_sharp;
            }else if (e.contains('醫')) {
              return Icons.medical_services_sharp;
            }else{
              return Icons.business_sharp;
            }

          }()),
        ),
        onTap: (){
          close(context, int.parse(e.substring(0,4)));
        }
      )).toList(),
    );
  }
}
