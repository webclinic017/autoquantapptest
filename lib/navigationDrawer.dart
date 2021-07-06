import 'package:flutter/material.dart';
import 'utils/constants.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,

        children: <Widget> [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: themeData.accentColor,
            ),
            child: Center(
              child: Text('AutoQuant', style: TextStyle(
                color: COLOR_WHITE,
                fontSize: 30,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              )),
            ),
          )
        ]

      )

    );
  }
}
