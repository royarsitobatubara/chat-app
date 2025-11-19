import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Test API GET', () async {
    final res = await http.get(Uri.parse("http://localhost:3000/api/ping"));
    expect(res.statusCode, 200);
  });
}
