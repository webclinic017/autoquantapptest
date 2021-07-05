import 'package:flutter/material.dart';
import 'utils/constants.dart';


class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);

    return AppBar(
      foregroundColor: COLOR_GREY,
      backgroundColor: COLOR_WHITE,
      backwardsCompatibility: false,
      title: Text('Welcome, guest_53', style: themeData.textTheme.headline4),
      leading: IconButton(
        icon: const Icon(Icons.menu_sharp),
        onPressed:(){
          print('hi');
        }
      ),
      actions: <Widget> [
        IconButton(
          icon: const Icon(Icons.notifications_none_sharp),
          onPressed:(){

          }
        ),
        IconButton(
            icon: const Icon(Icons.chat_sharp),
            onPressed:(){

            }
        )
      ]
    );
  }
}
