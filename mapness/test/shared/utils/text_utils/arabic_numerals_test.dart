import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

void main() {
  group('toArabicIndicDigits', () {
    test('substitutes every ASCII digit', () {
      expect(toArabicIndicDigits('0123456789'), '٠١٢٣٤٥٦٧٨٩');
    });

    test('leaves separators, letters and bidi marks intact', () {
      expect(toArabicIndicDigits('12:34'), '١٢:٣٤');
      expect(toArabicIndicDigits('1,234.5'), '١,٢٣٤.٥');
      expect(toArabicIndicDigits('12 كم'), '١٢ كم');
      expect(toArabicIndicDigits('‎-5'), '‎-٥');
    });

    test('returns the same instance when there is nothing to shape', () {
      const value = 'كم';
      expect(toArabicIndicDigits(value), same(value));
      expect(toArabicIndicDigits(''), same(''));
    });

    test('is idempotent', () {
      final once = toArabicIndicDigits('45 min');
      expect(toArabicIndicDigits(once), once);
    });

    group('minus sign handling', () {
      test('marks a leading sign with LRM so it stays left of the digits', () {
        expect(toArabicIndicDigits('-4'), '‎-٤');
        expect(toArabicIndicDigits('-4º'), '‎-٤º');
        expect(toArabicIndicDigits('up to -12'), 'up to ‎-١٢');
      });

      test('leaves a hyphen between digits alone — it is a range, not a sign', () {
        expect(toArabicIndicDigits('07:00-19:00'), '٠٧:٠٠-١٩:٠٠');
        expect(toArabicIndicDigits('4-8'), '٤-٨');
      });

      test('does not double up an LRM that is already present', () {
        expect(toArabicIndicDigits('‎-5'), '‎-٥');
      });

      test('ignores a hyphen not followed by a digit', () {
        expect(toArabicIndicDigits('4 - abc'), '٤ - abc');
      });

      test('stays idempotent for signed values', () {
        final once = toArabicIndicDigits('-4');
        expect(toArabicIndicDigits(once), once);
      });
    });
  });

  group('digitsForLocale', () {
    test('shapes for ar and ar_SA', () {
      expect(digitsForLocale('ar', '7'), '٧');
      expect(digitsForLocale('ar_SA', '7'), '٧');
    });

    test('leaves non-Arabic locales untouched', () {
      expect(digitsForLocale('en', '7'), '7');
      expect(digitsForLocale('en_SA', '7'), '7');
    });
  });
}
