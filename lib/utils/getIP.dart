import 'package:http/http.dart' as http;


Future<String> getIP(String address) async {
  late String result;
  final response = await http.get(Uri.parse(address));
  if (response.statusCode == 200) {
    result = response.body;
  } else {
    print("Network Error: Failed to reach ${address}.");
  }
  return result;
}