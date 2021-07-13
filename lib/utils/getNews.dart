import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'newsInfo.dart';



Future<List<NewsInfo>> getNews(List<int> ids) async {
  try {
    List<NewsInfo> ret = [];

    for (int id in ids) {
      final response =
        await http.get(Uri.parse('${API_LOC}stock/market_news/$id'));
      if (response.statusCode != 200)
        throw Exception('Error: Code $response.statusCode');
      for (Map<String, dynamic> mp in jsonDecode(response.body)['data']) {
        ret.add(NewsInfo.fromJson(mp));
      }
    }

    ret.sort((a,b) => b.dateTime.compareTo(a.dateTime));

    return ret;
  }catch (err) {
    print('Loading error: $err');
    throw err;
  }
}