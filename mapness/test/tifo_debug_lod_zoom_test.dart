import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/tifo/data/tifo_debug_lod_zoom.dart';

/// The whole point of the LOD sliders is that no zoom level can ever belong
/// to two tiers at once — these cover the push behaviour that guarantees it,
/// from both ends of the axis.
void main() {
  late ProviderContainer container;
  TifoDebugLodZoomController controller() => container.read(tifoDebugLodZoomProvider.notifier);
  TifoLodZoomThresholds state() => container.read(tifoDebugLodZoomProvider);

  void expectDisjoint() {
    final s = state();
    expect(
      s.districtMaxZoom - s.clusterMaxZoom,
      greaterThanOrEqualTo(TifoLodZoomThresholds.tierGap),
      reason: 'districts must keep at least one zoom level above the cluster tier',
    );
    expect(
      s.buildingMinZoom - s.districtMaxZoom,
      TifoLodZoomThresholds.tierGap,
      reason: 'buildings must start exactly where districts end',
    );
    expect(s.clusterMaxZoom, greaterThanOrEqualTo(TifoLodZoomThresholds.minZoom));
    expect(s.buildingMinZoom, lessThanOrEqualTo(TifoLodZoomThresholds.maxZoom));
  }

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('defaults are the tiers the product asked for: cluster ≤ 9, districts 10-15, buildings ≥ 16', () {
    expect(state().clusterMaxZoom, 9);
    expect(state().districtMaxZoom, 15);
    expect(state().buildingMinZoom, 16);
    expectDisjoint();
  });

  test('raising the cluster boundary pushes districts (and buildings) up', () {
    controller().setClusterMaxZoom(17);

    expect(state().clusterMaxZoom, 17);
    expect(state().districtMaxZoom, 18);
    expect(state().buildingMinZoom, 19);
    expectDisjoint();
  });

  test('lowering the districts boundary pushes the cluster tier down', () {
    controller().setDistrictMaxZoom(5);

    expect(state().districtMaxZoom, 5);
    expect(state().clusterMaxZoom, 4);
    expectDisjoint();
  });

  test('the buildings slider is the districts boundary seen from above', () {
    controller().setBuildingMinZoom(6);

    expect(state().buildingMinZoom, 6);
    expect(state().districtMaxZoom, 5);
    expect(state().clusterMaxZoom, 4);
    expectDisjoint();
  });

  test('values past the ends of the axis are clamped, not overlapped', () {
    controller().setClusterMaxZoom(99);
    expect(state().clusterMaxZoom, TifoLodZoomThresholds.maxClusterMaxZoom);
    expectDisjoint();

    controller().setBuildingMinZoom(-5);
    expectDisjoint();

    controller().setDistrictMaxZoom(99);
    expect(state().buildingMinZoom, TifoLodZoomThresholds.maxZoom);
    expectDisjoint();
  });

  test('reset restores the defaults', () {
    controller().setClusterMaxZoom(16);
    controller().reset();

    expect(state(), const TifoLodZoomThresholds());
  });
}
