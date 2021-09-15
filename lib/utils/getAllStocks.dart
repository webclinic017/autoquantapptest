import 'fileActions.dart';
import 'getIP.dart';
import 'dart:convert';
// import 'basicKChart.dart';
import 'package:k_chart/flutter_k_chart.dart';

Map<int, Map<String, dynamic>> ? _stockCodes;
List<Map<String, dynamic> > ? _stockList;

Future<void> _updateStockCodes() async {
  if (_stockCodes != null) return;
  try{
    String codes = await getIP('https://autoquant.ai/api/v1/stock_codes');
    List<dynamic> mp = json.decode(codes)['data'];
    _stockCodes = Map<int, Map<String, dynamic> > ();
    _stockList = [];
    for (Map<String, dynamic> ss in mp) {
      _stockCodes![int.parse(ss['股票代號'])] = ss;
      _stockList!.add(ss);
    }
  }catch(err) {
    print("Error while updating stock codes: $err");
    _stockCodes = null;
  }
}

Future<List<KLineEntity>?> getKChartData(int stockID, {int? longDays, int? shortDays}) async {
  Map<int, Map<String, dynamic> > dateToModel = {};

  final List<dynamic> pred = await getStockPrediction(stockID: stockID.toString());
  for (Map<String, dynamic> mp in pred) {
    if (mp['y_agg'] != -1)
      dateToModel[DateTime.parse(mp["date"]).millisecondsSinceEpoch]
      = mp;
  }

  final result = await getIP('https://autoquant.ai/api/v1/stock/ohlc/$stockID');
  List<KLineEntity>? datas;
  try{
    final Map parseJson = json.decode(result) as Map<String, dynamic>;
    final list = parseJson['data']['ticks'];
    datas = [];
    int contSum = 0;
    for (Map<String, dynamic> item in list) {
      int timeStamp = DateTime.parse(item["Date"]).millisecondsSinceEpoch;
      double? modelvalue = dateToModel[timeStamp]!=null?dateToModel[timeStamp]!['y_agg'] : null;
      LabelType? label = null;
      if (modelvalue != null) {
        if (modelvalue > 0.5) {
          if (contSum < 0) contSum = 0;
          contSum ++;
        }else if (modelvalue < 0.5){
          if (contSum > 0) contSum = 0;
          contSum --;
        }
        if (longDays != null && contSum == longDays) {
          label = LabelType.Long;
          print ("long!!!");
        }
        if (shortDays != null && contSum == -shortDays) {
          label = LabelType.Short;
        }
      }
      datas.add(KLineEntity.fromCustom(
        amount: item["Volume"].toDouble(),
        high: item["High"].toDouble(),
        low: item["Low"].toDouble(),
        open: item["Open"].toDouble(),
        close: item["Close"].toDouble(),
        vol: item["Volume"].toDouble(),
        time: timeStamp,
        modelvalue:modelvalue,
        label: label,
      ));
    }
    DataUtil.calculate(datas);

    return datas;
  } catch (e) {
    print("Error: e");
    return null;
  }
}

Future<Map<dynamic,dynamic>> getStockRealtime({bool singleStock = true, required String stockID}) async {
  String res = await getIP(
      "https://autoquant.ai/api/v1/${singleStock?"stock":"index"}/realtime/${stockID}"
  );
  final parseJson = json.decode(res) as Map<String, dynamic>;
  return parseJson['data'];
}

Future<List<dynamic> > getStockPrediction({required String stockID}) async{
  String res = await getIP(
      "https://autoquant.ai/api/v1/stock/model/prediction/${stockID}"
  );
  final parseJson = json.decode(res) as Map<String, dynamic>;
  return parseJson['data'];
}

Future<List<dynamic> > getStockScreen({required int long, required int short, bool shortFirst=true}) async{
  String ls = "long$long";
  String ss = "short$short";
  String res = await getIP(
      "https://autoquant.ai/api/v1/stockScreener/longShort/?query=${shortFirst?ss+ls:ls+ss}"
  );
  final parseJson = json.decode(res) as Map<String, dynamic>;
  return parseJson['data'];
}


Future<Map<dynamic,dynamic> > getStockRiskRank({required String stockID}) async{
  String res = await getIP(
      "https://autoquant.ai/api/v1/stock/risk_rank/${stockID}"
  );
  final parseJson = json.decode(res) as Map<String, dynamic>;
  return parseJson['data'];
}

Future<List<dynamic> > getStockIncomeStatement({required String stockID}) async{
  String res = await getIP(
      "https://autoquant.ai/api/v1/stock/finance/income_statement/${stockID}"
  );
  final parseJson = json.decode(res) as Map<String, dynamic>;
  return parseJson['data'];
}

Future<List<dynamic> > getMarketDaily(String who) async{
  print('https://autoquant.ai/api/v1/index/ohlc/${who}:INDEX');
  String res = await getIP(
      'https://autoquant.ai/api/v1/index/ohlc/${who}:INDEX'
  );


  final parseJson = json.decode(res) as Map<String, dynamic>;
  return parseJson['data']['ticksData'];
}


Future<Map<dynamic, dynamic> > getModelMonitor({required String stockID}) async{
  String res = await getIP(
      "https://autoquant.ai/api/v1/stock/model/monitor/${stockID}"
  );
  final parseJson = json.decode(res) as Map<String, dynamic>;
  return parseJson['data'];
}

Future<List<dynamic> > getMarketScore() async{
  String res = await getIP(
      "https://autoquant.ai/api/v1/marketScore"
  );
  final parseJson = json.decode(res) as Map<String, dynamic>;
  return parseJson['data'];
}



Future<void> updateDatabase() async {
  print("Database Update Called");
  await _updateStockCodes();
}

String nameOfID(int stockID) {
  try{
    if (_stockCodes == null) {
      print("Stockcodes is null!!!");
    }
    return _stockCodes![stockID]!['股票名稱'].toString();
  }catch(err) {
    print("Error: $err");
    return "Error ";
  }
}

List<Map<String, dynamic> > getStockList(){
  return _stockList!;
}