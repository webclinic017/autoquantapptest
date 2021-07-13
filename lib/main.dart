import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'utils/constants.dart';
import 'topBar.dart';
import 'navigationDrawer.dart';
import 'package:http/http.dart' as http;

void main() {
  // imageCache?.clear();
  // var date = DateTime.fromMillisecondsSinceEpoch(1626096600000);
  // print (date);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: COLOR_GREY,
        primaryColorLight: COLOR_WHITE,
        backgroundColor: COLOR_VERY_LIGHT_GREY,
        accentColor: COLOR_BLUE,
        textTheme: MAIN_TEXT_THEME,
        fontFamily: 'Titillium'
      ),
      home: Scaffold(
        // color: COLOR_VERY_LIGHT_GREY,
        appBar: TopBar(),
        drawer: NavigationDrawer(),
        body: Column(
          children: <Widget>[
            // TopBar(),
            Expanded(
              child: Dashboard(),
            )
          ],
        )
      )
    );
  }
}

