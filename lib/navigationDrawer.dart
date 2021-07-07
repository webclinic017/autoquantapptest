import 'package:flutter/material.dart';
import 'utils/constants.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 250,
      child: Drawer(
        child: Material(
          color: themeData.accentColor,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 3),

            children: <Widget> [
              Container(
                height: 120,
                margin: EdgeInsets.symmetric(vertical:5, horizontal:10),
                padding: EdgeInsets.only(top:30, left:5, right: 5, bottom:0),
                child: Center(
                  child: Text('AutoQuant', style: TextStyle(
                    color: COLOR_WHITE,
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  )),
                ),
              ),

              menuDivider(
                themeData:themeData,
              ),

              menuItem(
                title: 'Dashboard',
                icon: Icons.dashboard_sharp,
                themeData: themeData,
              ),


              subSection(
                title: '市場行情與資訊',
                themeData: themeData,
              ),

              menuItem(
                title: '大盤與國際市場指數',
                icon: Icons.public,
                themeData: themeData,
              ),

              menuItem(
                title: '產業類股與概念股',
                icon: Icons.corporate_fare_sharp,
                themeData: themeData,
              ),

              subSection(
                title: '進階功能',
                themeData: themeData,
              ),

              menuItem(
                title: '多空快速篩選',
                icon: Icons.radar_sharp,
                themeData: themeData,
              ),

              menuItem(
                title: '多因子選股',
                icon: Icons.checklist_sharp,
                themeData: themeData,
              ),

              menuItem(
                title: '法人主力籌碼',
                icon: Icons.show_chart_sharp,
                themeData: themeData,
              ),

              menuItem(
                title: '個股回測',
                icon: Icons.bar_chart_sharp,
                themeData: themeData,
              ),

              menuItem(
                title: '投資組合管理',
                icon: Icons.inventory_sharp,
                themeData: themeData,
              ),

              menuItem(
                title: '蒙地卡羅模擬',
                icon: Icons.multiline_chart_sharp,
                themeData: themeData,
              ),

              subSection(
                title: '個人化',
                themeData: themeData,
              ),

              menuItem(
                title: '風險適性評量表',
                icon: Icons.dangerous_sharp,
                themeData: themeData,
              ),

              menuItem(
                title: '我的收藏',
                icon: Icons.bookmarks_sharp,
                themeData: themeData,
              ),
            ]

          )

        )
      )
    );
  }

  Widget menuDivider({
    required ThemeData themeData,
  }){
    return Divider(color: themeData.primaryColorLight,
        indent:20, endIndent:20);
  }

  Widget subSection({
    required String title,
    required ThemeData themeData,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left:20),
          child: Text(title, style: TextStyle(
            color: themeData.primaryColorLight,
            fontWeight: FontWeight.w300,
            fontSize: 16,
          )),
        ),
        menuDivider(themeData:themeData),
      ],
    );
  }
  Widget menuItem({
    required String title,
    required IconData icon,
    required ThemeData themeData,
    VoidCallback? onTap,
  }){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: themeData.primaryColorLight),
        minLeadingWidth: 0,
        title: Text(title, style: TextStyle(
          color: themeData.primaryColorLight,
          fontWeight: FontWeight.w400,
          fontSize: 18,
        )),
        hoverColor: Colors.white70,
        onTap: () {
          onTap;
        },
      ),
    );
  }
}
