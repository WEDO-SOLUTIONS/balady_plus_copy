import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/entities/bus/model.dart';
import 'package:mapness/features/jeddah_bus/provider.dart';

BusCoordinates _p(double lat, double lon) => BusCoordinates(latitude: lat, longitude: lon);

void main() {
  group('dropNearDuplicatePoints', () {
    test('empty input stays empty', () {
      expect(dropNearDuplicatePoints(const []), isEmpty);
    });

    test('single point is kept', () {
      final result = dropNearDuplicatePoints([_p(21.434149, 39.356944)]);
      expect(result, [_p(21.434149, 39.356944)]);
    });

    test('distinct points are all kept', () {
      final input = [_p(21.4341, 39.3569), _p(21.4351, 39.3579), _p(21.4361, 39.3589)];
      expect(dropNearDuplicatePoints(input), input);
    });

    test('near-duplicate consecutive point is removed, first of the run kept', () {
      // real gist pair, L10 forward idx 507-508, 0.152 m apart
      final input = [_p(21.434180, 39.355703), _p(21.434179, 39.355704)];
      expect(dropNearDuplicatePoints(input), [_p(21.434180, 39.355703)]);
    });

    test('a run of several near-duplicates collapses to its first point', () {
      final input = [
        _p(21.434180, 39.355703),
        _p(21.434179, 39.355704),
        _p(21.4341805, 39.3557025),
        _p(21.440000, 39.360000),
      ];
      expect(
        dropNearDuplicatePoints(input),
        [_p(21.434180, 39.355703), _p(21.440000, 39.360000)],
      );
    });

    test('true end of the line is kept when distinct from its predecessor', () {
      final input = [_p(21.4341, 39.3569), _p(21.4341, 39.3569 + 5e-5), _p(21.4400, 39.3600)];
      final result = dropNearDuplicatePoints(input);
      expect(result.last, _p(21.4400, 39.3600));
    });

    test('last point near-duplicate of the previous kept one is dropped, staying within threshold', () {
      final input = [_p(21.4341, 39.3569), _p(21.4341, 39.3569 + 5e-5), _p(21.4341, 39.3569 + 5.5e-5)];
      final result = dropNearDuplicatePoints(input);
      expect(result.length, 2);
      expect((result.last.longitude - input.last.longitude).abs(), lessThan(jeddahBusMinPointDeltaDegrees));
    });
  });
}
