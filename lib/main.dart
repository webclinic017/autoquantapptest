import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'utils/constants.dart';
import 'topBar.dart';

void main() {
  // imageCache?.clear();
  runApp(MyApp());
}

class ColorButton extends StatefulWidget {
  const ColorButton({Key? key}) : super(key: key);

  @override
  _ColorButtonState createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton> {
  @override
  int MyColor = 0;
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('hi');
        setState(() {
          MyColor ^= 1;
        });
      },
      child: Container(
        height: 50.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: MyColor == 0? Colors.lightGreen[500] : Colors.amberAccent,
        ),
        child: Center(
          child: Text('Engage $MyColor'),
        ),
      ),
    );
  }
}


class StatDisplayBar extends StatelessWidget {
  const StatDisplayBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}




class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcomeeeee to Flutter!',

      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: COLOR_GREY,
        backgroundColor: COLOR_VERY_LIGHT_GREY,
        accentColor: COLOR_BLUE,
        textTheme: MAIN_TEXT_THEME,
        fontFamily: 'Titillium'
      ),
      home: Container(
        color: COLOR_VERY_LIGHT_GREY,
        child: Column(
          children: <Widget>[
            TopBar(),
            Expanded(
              child: Dashboard(),
            )
          ],
        )
      )
    );
  }
}

