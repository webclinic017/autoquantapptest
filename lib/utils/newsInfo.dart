

class NewsInfo{
  final DateTime dateTime;
  final int ID;
  final String name;
  final String title;
  final String text;
  final int rTime;
  final String related;
  NewsInfo({
    required this.dateTime,
    required this.ID,
    required this.name,
    required this.title,
    required this.text,
    required this.rTime,
    required this.related,
  });

  factory NewsInfo.fromJson(Map<String, dynamic> json) {
    print(int.parse(json['代號']));
    return NewsInfo(
      // dateTime: DateTime.parse(json['發布日期時間']),
      // ID: int.parse(json['代號']),
      // name: json['名稱'],
      // title: json['新聞標題'],
      // text: json['新聞內容'],
      // rTime: int.parse(json['RTIME']),
      // related: json['相關個股'],
      dateTime: DateTime.parse(json['發布日期時間']),
      ID: 2330,
      name: json['名稱'],
      title: json['新聞標題'],
      text: json['新聞內容'],
      rTime: 12345,
      related: json['相關個股'],
    );
  }

}