import 'package:flutter/material.dart';

Future<T?> textDialogInput<T>(
  BuildContext context, {
    required String title,
    required String value,
    String enterText = '輸入',
  }
) => showDialog<T>(
  context: context,
  builder: (context) => TextDialogWidget(
    title: title,
    value: value,
    enterText: enterText,
  ),
);

class TextDialogWidget extends StatefulWidget {
  final String title;
  final String value;
  final String enterText;

  const TextDialogWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.enterText,
  }) : super(key: key);

  @override
  _TextDialogWidgetState createState() => _TextDialogWidgetState();
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
    ),
    actions: [
      ElevatedButton(
        child: Text(widget.enterText),
        onPressed: () => Navigator.of(context).pop(controller.text),
      )
    ],
  );
}