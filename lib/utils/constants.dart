import 'package:flutter/material.dart';

const COLOR_BLACK = Color.fromRGBO(48,48,48,1.0);
const COLOR_DARK_GREY = Color.fromRGBO(110,110,130,1.0);
const COLOR_GREY  = Color.fromRGBO(141, 141, 141, 1.0);
const COLOR_LIGHT_GREY = Color.fromRGBO(230,230,230,1.0);
const COLOR_VERY_LIGHT_GREY = Color.fromRGBO(245,245,245,1.0);
const COLOR_WHITE = Colors.white;
const COLOR_BLUE =  Color.fromRGBO(114,118,255,1.0);

const TextTheme MAIN_TEXT_THEME = TextTheme(
  headline1: TextStyle(
      color: COLOR_DARK_GREY, fontWeight: FontWeight.w300, fontSize: 36),
  headline2: TextStyle(
      color: COLOR_BLUE, fontWeight: FontWeight.w700, fontSize: 30),
  headline3: TextStyle(
      color: COLOR_BLUE, fontWeight: FontWeight.w600, fontSize: 26),
  headline4: TextStyle(
      color: COLOR_GREY, fontWeight: FontWeight.w300, fontSize: 22),
  headline5: TextStyle(
      color: COLOR_BLUE, fontWeight: FontWeight.w700, fontSize: 20),
  headline6: TextStyle(
      color: COLOR_BLUE, fontWeight: FontWeight.w700, fontSize: 18),

  bodyText1: TextStyle(
      color: COLOR_BLACK, fontWeight: FontWeight.w300, fontSize: 16, height: 1.2),
  bodyText2: TextStyle(
      color: COLOR_GREY, fontWeight: FontWeight.w300, fontSize: 15, height: 1.5),

  subtitle1: TextStyle(
      color: COLOR_BLACK, fontWeight: FontWeight.w200, fontSize: 14, height: 1.5),
  subtitle2: TextStyle(
      color: COLOR_GREY, fontWeight: FontWeight.w200, fontSize: 14, height: 1.5),


);