import 'package:flutter/material.dart';
import 'utils/constants.dart';


class TopBar extends StatelessWidget implements PreferredSizeWidget{

  String title;
  bool subPage;

  TopBar({this.title='Welcome, Guest_53', this.subPage=false, Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);

    return AppBar(
      foregroundColor: themeData.primaryColor,
      backgroundColor: themeData.primaryColorLight,
      backwardsCompatibility: false,
      title: Text(title, style: themeData.textTheme.headline4),
      leading: subPage?
      IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed:(){
            Navigator.pop(context);
          }
      ):
      IconButton(
        icon: const Icon(Icons.menu_sharp),
        onPressed:(){
          Scaffold.of(context).openDrawer();
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
