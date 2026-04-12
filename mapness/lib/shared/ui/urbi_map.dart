import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/map/navigation_controls_visibility.dart';

class UrbiMap extends ConsumerWidget {
  const UrbiMap({
    required this.onMapCreated,
    this.androidUseExpensive = false,
    super.key,
  });

  final Function(DgisMapController controller) onMapCreated;
  final bool androidUseExpensive;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Listener(
    behavior: HitTestBehavior.translucent,
    onPointerDown: (_) => ref.read(navigationControlsVisibilityProvider.notifier).registerInteraction(),
    onPointerSignal: (_) => ref.read(navigationControlsVisibilityProvider.notifier).registerInteraction(),
    child: DgisMap(
      key: key,
      androidUseExpensive: androidUseExpensive,
      onMapCreated: onMapCreated,
    ),
  );
}
