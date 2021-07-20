import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Json File of all stock ids stored in "stock_codes"

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> _getFile(String str) async {
  final path = await _localPath;
  return File('$path/$str.txt');
}

Future<String> readFile(String str) async {
  try{
    return await (await _getFile(str) ) .readAsString();
  } catch (e) {
    return "Error!";
  }
}

Future<File> writeFile(String file, String content) async {
  return (await _getFile(file)).writeAsString(content);
}