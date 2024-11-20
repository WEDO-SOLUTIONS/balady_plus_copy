import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';

class PoiLoadingSheet extends ConsumerWidget {
  final DgisObjectIdMessage objectId;

  const PoiLoadingSheet({
    required this.objectId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 148,
          width: double.infinity,
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: SheetDragger(),
                ),
              ),
              Positioned(
                right: 16,
                top: 16,
                child: CustomCloseButton(
                  onClose: () {
                    ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
                    ref.read(highlightProvider.notifier).removeHighlight(objectId);
                    context.router.back();
                  },
                ),
              ),
              Center(
                child: Loading.medium(title: context.l10n.loading),
              ),
            ],
          ),
        ),
      );
}
