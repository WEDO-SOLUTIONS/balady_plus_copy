import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UrbiMap extends ConsumerWidget {
  const UrbiMap({
    required this.onMapCreated,
    this.androidUseExpensive = false,
    super.key,
  });

  final Function(DgisMapController controller) onMapCreated;
  final bool androidUseExpensive;

  @override
  Widget build(BuildContext context, WidgetRef ref) => DgisMap(
        key: key,
        androidUseExpensive: androidUseExpensive,
        onMapCreated: onMapCreated,
      );
}
