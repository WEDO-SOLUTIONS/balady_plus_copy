import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/entities/hajj/poi_marker_rcmc.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/helpers/throttled_callback_widget.dart';

class HajjPoiCardFooter extends HookConsumerWidget {
  final PoiMarkerRcmc poiMarkerRcmc;
  final Future Function() share;
  final VoidCallback? callPhone;
  final VoidCallback onTapCar;
  final StatefulBottomSheetController<PoiCardBottomSheetState>? bottomSheetController;

  const HajjPoiCardFooter({
    required this.onTapCar,
    required this.poiMarkerRcmc,
    required this.share,
    this.callPhone,
    this.bottomSheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayShadow = useState(true);
    final bottomSheetController = this.bottomSheetController;

    if (bottomSheetController != null) {
      useEffect(() {
        void updateShadow() {
          final isHidden = bottomSheetController.state == PoiCardBottomSheetState.hidden &&
              bottomSheetController.interpolation == 0.0;
          if (!isHidden != displayShadow.value) {
            displayShadow.value = !isHidden;
          }
        }

        bottomSheetController.addListener(updateShadow);

        return () => bottomSheetController.removeListener(updateShadow);
      });
    }

    return ThrottledCallbackWidget(
      callback: share,
      resetAfterFutureCompleted: true,
      builder: (context, throttledShare) => BottomActionBar(
        displayShadow: displayShadow.value,
        items: [
          ItemActionBar(
            icon: TransportIcons.locationDirectionNavigator,
            buttonType: BaladyButtonType.primary,
            label: context.l10n.poiCardDirections,
            onPressed: onTapCar,
          ),
          if (poiMarkerRcmc.contactInfo != null && callPhone != null)
            ItemActionBar(
              icon: GeneralIcons.phoneLTR,
              buttonType: BaladyButtonType.secondary,
              onPressed: callPhone!,
            ),
          ItemActionBar(
            icon: SystemIcons.share,
            buttonType: BaladyButtonType.secondary,
            onPressed: throttledShare,
          ),
        ],
      ),
    );
  }
}
