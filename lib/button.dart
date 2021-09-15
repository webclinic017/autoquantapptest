import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final bool selected;
  final String title;
  final VoidCallback onPressed;

  const Button({
    required Key key,
    required this.selected,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return TextButton(
      style: TextButton.styleFrom(
        primary: themeData.accentColor,
        backgroundColor: selected ? themeData.primaryColorLight: themeData.buttonColor,
      ),
      child: Text(title, style: themeData.textTheme.headline2!.copyWith(
        fontSize: 15,
      )),
      onPressed: () {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          alignment: 0.5,
        );
        onPressed();
      },
    );
  }
}
