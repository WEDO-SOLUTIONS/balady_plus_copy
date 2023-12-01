import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/poi_card/widgets/shimmer.dart';
import 'package:mapness/features/iwish/providers/iwish_markers.dart';
import 'package:mapness/pages/iwish/ui/iwish_dashboard_item.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class IwishDashboardWidget extends StatelessWidget {
  const IwishDashboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final markers = ref.watch(iwishMarkersProvider);

      if (markers.isLoading) {
        return const Row(children: [
          ShimmerEffectWidget(width: 200),
          ShimmerEffectWidget(width: 200)
        ]);
      }
      if (markers.hasError) {
        return LabeledElevatedButton(
          onPressed: () => ref.read(iwishMarkersProvider.notifier).refresh(),
          label: context.l10n.reload,
        );
      }

      final data = markers.requireValue;
      final marker1 = data.elementAtOrNull(0);
      final marker2 = data.elementAtOrNull(1);
      return Row(
        children: [
          if (marker1 != null) IwishDashboardItem(id: marker1.id),
          // if (marker2 != null) ...[
          //   const SizedBox(width: 8),
          //   IwishDashboardItem(id: marker2.id),
          // ]
        ],
      );
    });
  }
}
