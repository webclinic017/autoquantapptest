import 'package:flutter/material.dart';
import 'utils/constants.dart';


class TopBar extends StatelessWidget implements PreferredSizeWidget{
  const TopBar({Key? key}) : super(key: key);

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
      title: Text('Welcome, guest_53', style: themeData.textTheme.headline4),
      leading: IconButton(
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
