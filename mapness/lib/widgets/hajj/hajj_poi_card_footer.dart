import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/entities/hajj/poi_marker_rcmc.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class HajjPoiCardFooter extends HookConsumerWidget {
  final PoiMarkerRcmc poiMarkerRcmc;
  final VoidCallback? callPhone;
  final VoidCallback onTapCar;
  final StatefulBottomSheetController<PoiCardBottomSheetState>? bottomSheetController;

  const HajjPoiCardFooter({
    required this.onTapCar,
    required this.poiMarkerRcmc,
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

    return BottomActionBar(
      displayShadow: displayShadow.value,
      items: [
        ItemActionBar(
          icon: TransportIcons.locationDirectionNavigator,
          buttonType: ButtonType.primary,
          label: context.l10n.poiCardDirections,
          onPressed: onTapCar,
        ),
        if (poiMarkerRcmc.contactInfo != null && callPhone != null)
          ItemActionBar(
            icon: GeneralIcons.phoneLTR,
            buttonType: ButtonType.secondary,
            onPressed: callPhone!,
          ),
      ],
    );
  }
}
