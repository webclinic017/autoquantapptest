import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'utils/constants.dart';

import 'utils/getAllStocks.dart';
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
    print("hey");
    return FutureBuilder(
      future: updateDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }else {
          return MaterialApp(

            theme: ThemeData(
              // primarySwatch: Colors.blue,
              primaryColor: COLOR_GREY,
              primaryColorLight: COLOR_WHITE,
              backgroundColor: COLOR_VERY_LIGHT_GREY,
              accentColor: COLOR_BLUE,
              textTheme: MAIN_TEXT_THEME,
              buttonColor: COLOR_LIGHT_GREY,
              fontFamily: 'Titillium'
            ),
            home: Dashboard(),
          );

        }
      }

    );
  }
}

