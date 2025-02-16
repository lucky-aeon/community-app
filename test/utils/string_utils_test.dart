import 'package:flutter_test/flutter_test.dart';

void main() {
  group('String Utils Tests', () {
    test('String is empty', () {
      expect(''.isEmpty, true);
      expect('hello'.isEmpty, false);
    });

    test('String contains substring', () {
      const string = 'Hello World';
      expect(string.contains('World'), true);
      expect(string.contains('Flutter'), false);
    });
  });
}
