import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/classes/address.dart';

void main() {
  late Address sut;

  setUp(() {});

  arrangeValidAddress() {
    sut = Address('123 Main St', 'Anytown', 12345, 12.345, 67.890);
  }

  group('Address Tests', () {
    test('toJson should return a valid map', () {
      arrangeValidAddress();

      final json = sut.toJson();

      expect(json['street'], equals('123 Main St'));
      expect(json['city'], equals('Anytown'));
      expect(json['postalCode'], equals(12345));
      expect(json['long'], equals(12.345));
      expect(json['lat'], equals(67.890));
    });

    test('toString should return a formatted string', () {
      arrangeValidAddress();

      final string = sut.toString();

      expect(string, equals('123 Main St, 12345\nAnytown'));
    });

    test('Getters should return correct values', () {
      arrangeValidAddress();

      expect(sut.street, equals('123 Main St'));
      expect(sut.city, equals('Anytown'));
      expect(sut.postalCode, equals(12345));
      expect(sut.long, equals(12.345));
      expect(sut.lat, equals(67.890));
    });
  });
}
