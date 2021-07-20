import 'fileActions.dart';
import 'getIP.dart';
import 'dart:convert';


Future<Map<String, dynamic>> getStockCodes() async {
  String codes = await readFile('stock_codes');
  if (codes == "Error!" || codes == "") {
    codes = await getIP('https://autoquant.ai/api/v1/stock_codes');
    await writeFile('stock_codes', codes);
  }
  return json.decode(codes) as Map<String, dynamic>;
}