import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SystemIcons text direction test', () {
    test('SystemIcons arrowCornerLeftLarge', () {
      expect(SystemIcons.arrowCornerLeftLarge.matchTextDirection, true);
    });

    test('SystemIcons arrowCornerLeftSmall', () {
      expect(SystemIcons.arrowCornerLeftSmall.matchTextDirection, true);
    });

    test('SystemIcons arrowCornerRightLarge', () {
      expect(SystemIcons.arrowCornerRightLarge.matchTextDirection, true);
    });

    test('SystemIcons arrowCornerRightSmall', () {
      expect(SystemIcons.arrowCornerRightSmall.matchTextDirection, true);
    });

    test('SystemIcons arrowLeft', () {
      expect(SystemIcons.arrowLeft.matchTextDirection, true);
    });

    test('SystemIcons arrowRight', () {
      expect(SystemIcons.arrowRight.matchTextDirection, true);
    });
  });

  group('Sar text span test', () {
    test('GeneralIcons test', () {
      expect(GeneralIcons.sarSpan(), isA<TextSpan>());
      expect(GeneralIcons.sarSpan().text, equals('\ufdfc'));
      expect(GeneralIcons.sar.codePoint, equals(0xfdfc));
    });

    test('General32Icons test', () {
      expect(General16Icons.sar.codePoint, equals(0xfdfc));
    });
  });
}
