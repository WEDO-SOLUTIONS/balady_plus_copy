// ignore_for_file: cascade_invocations

import 'package:dgis_map/library.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/shared/utils/camera_refetch_gate.dart';

/// A viewport centred on ([lat], [lon]) that is about 3 km wide (street/neighbourhood zoom).
VisibleRect rect({double lat = 24.7136, double lon = 46.6753, double zoom = 14}) => VisibleRect(
  northEastLat: lat + 0.0135,
  northEastLon: lon + 0.0135,
  southWestLat: lat - 0.0135,
  southWestLon: lon - 0.0135,
  zoom: zoom,
);

const _tick = Duration(milliseconds: 20);

Future<void> settle([Duration? duration]) => Future<void>.delayed(duration ?? _tick);

void main() {
  late List<VisibleRect> requests;
  late bool succeed;

  CameraRefetchGate gate({
    bool refineUnbounded = true,
    bool paused = false,
    Duration minInterval = Duration.zero,
    Duration resumeDelay = const Duration(milliseconds: 5),
  }) => CameraRefetchGate(
    refetch: (rect) async {
      requests.add(rect);
      return succeed;
    },
    minInterval: minInterval,
    resumeDelay: resumeDelay,
    refineUnbounded: refineUnbounded,
    paused: paused,
  );

  setUp(() {
    requests = [];
    succeed = true;
  });

  test('a small pan does not refetch, a pan to another city does', () async {
    final g = gate()..markFetched(rect());

    g.onCamera(rect(lat: 24.7136 + 0.02)); // ~2 km
    await settle();
    expect(requests, isEmpty);

    g.onCamera(rect(lat: 21.4225, lon: 39.8262)); // Riyadh -> Makkah
    await settle();
    expect(requests, hasLength(1));
    expect(requests.single.zoom, 14);
    g.dispose();
  });

  test('a large zoom change refetches even without moving the centre', () async {
    final g = gate()..markFetched(rect());

    g.onCamera(rect(zoom: 12));
    await settle();
    expect(requests, isEmpty);

    g.onCamera(rect(zoom: 8));
    await settle();
    expect(requests, hasLength(1));
    g.dispose();
  });

  test('movement is measured from the last request, not from the previous camera event', () async {
    final g = gate()..markFetched(rect());

    // Six 2 km steps in a row: no single step is meaningful, but together they are.
    for (var i = 1; i <= 6; i++) {
      g.onCamera(rect(lat: 24.7136 + 0.02 * i));
    }
    await settle();
    expect(requests, hasLength(1));
    g.dispose();
  });

  test('paused: nothing is requested, resuming catches up once if the camera moved', () async {
    final g = gate(paused: true)..markFetched(rect());

    g.onCamera(rect(lat: 21.4225, lon: 39.8262));
    g.onCamera(rect(lat: 21.4300, lon: 39.8300));
    await settle();
    expect(requests, isEmpty);

    g.paused = false;
    await settle();
    expect(requests, hasLength(1));
    expect(requests.single.northEastLat, closeTo(21.4300 + 0.0135, 1e-9));
    g.dispose();
  });

  test('paused: resuming without a meaningful move requests nothing', () async {
    final g = gate(paused: true)..markFetched(rect());

    g.onCamera(rect(lat: 24.7136 + 0.02));
    g.paused = false;
    await settle();
    expect(requests, isEmpty);
    g.dispose();
  });

  test('the first camera position refines content that was requested without a viewport', () async {
    final g = gate()..markFetched(null);

    g.onCamera(rect());
    await settle();
    expect(requests, hasLength(1));

    // From then on it is measured against that viewport.
    g.onCamera(rect(lat: 24.7136 + 0.02));
    await settle();
    expect(requests, hasLength(1));
    g.dispose();
  });

  test('refineUnbounded: false adopts the first camera position without a request', () async {
    final g = gate(refineUnbounded: false)..markFetched(null);

    g.onCamera(rect());
    await settle();
    expect(requests, isEmpty);

    g.onCamera(rect(lat: 21.4225, lon: 39.8262));
    await settle();
    expect(requests, hasLength(1));
    g.dispose();
  });

  test('min interval: an early camera event is deferred, not dropped', () async {
    final g = gate(minInterval: const Duration(milliseconds: 80))..markFetched(rect());
    await settle(const Duration(milliseconds: 100));

    g.onCamera(rect(lat: 21.4225, lon: 39.8262));
    await settle();
    expect(requests, hasLength(1));

    // Too soon after the previous request: waits for the interval and lands on the latest position.
    g.onCamera(rect(lat: 26.4207, lon: 50.0888));
    g.onCamera(rect(lat: 24.4700, lon: 39.6100));
    await settle();
    expect(requests, hasLength(1));

    await settle(const Duration(milliseconds: 100));
    expect(requests, hasLength(2));
    expect(requests.last.northEastLat, closeTo(24.4700 + 0.0135, 1e-9));
    g.dispose();
  });

  test('a failed request does not count as covering the area', () async {
    final g = gate()..markFetched(rect());
    succeed = false;

    g.onCamera(rect(lat: 21.4225, lon: 39.8262));
    await settle();
    expect(requests, hasLength(1));

    succeed = true;
    g.onCamera(rect(lat: 21.4225, lon: 39.8262));
    await settle();
    expect(requests, hasLength(2));

    g.onCamera(rect(lat: 21.4225, lon: 39.8262));
    await settle();
    expect(requests, hasLength(2));
    g.dispose();
  });

  test('a disposed gate requests nothing', () async {
    final g = gate(paused: true)..markFetched(rect());
    g.onCamera(rect(lat: 21.4225, lon: 39.8262));
    g.paused = false;
    g.dispose();
    await settle();
    expect(requests, isEmpty);
  });
}
