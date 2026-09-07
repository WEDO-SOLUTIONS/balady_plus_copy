import 'package:balady_uikit/balady_uikit.dart' hide MapButton, TrafficControlStatus;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/navigator_auto_enable_parking.dart';
import 'package:mapness/shared/providers/map/parking_autoenabled_sheet_provider.dart';
import 'package:mapness/shared/providers/map/parking_state.dart';
import 'package:mapness/shared/providers/map/traffic_state.dart';
import 'package:mapness/shared/ui/map_controls/traffic_control.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class TrafficParkingControl extends ConsumerStatefulWidget {
  final bool trafficVisible;
  final bool parkingVisible;

  const TrafficParkingControl({
    super.key,
    this.trafficVisible = true,
    this.parkingVisible = true,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TrafficParkingState();
}

class _TrafficParkingState extends ConsumerState<TrafficParkingControl> {
  @override
  Widget build(BuildContext context) {
    final trafficState = ref.watch(trafficStateProvider);
    final trafficNotifier = ref.read(trafficStateProvider.notifier);
    final isTrafficVisable = widget.trafficVisible && trafficState.status != TrafficControlStatus.hidden;
    final isTrafficEnabled = trafficState.status == TrafficControlStatus.enabled;

    final sharedPrefs = ref.read(sharedPrefsProvider);

    return SizedBox(
      width: 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isTrafficVisable)
            _TrafficControl(
              isEnabled: isTrafficEnabled,
              trafficState: trafficNotifier,
              isVisable: isTrafficVisable,
              parkingVisible: widget.parkingVisible,
            ),
          if (widget.parkingVisible)
            Consumer(
              builder: (context, ref, child) {
                final parkingState = ref.watch(parkingStateProvider);

                final layersNotifier = ref.watch(layersControlsProvider.notifier);
                final layers = ref.watch(layersControlsProvider);
                final isParkingEnabled = parkingState.visible;

                return _ParkingWidget(
                  isEnabled: isParkingEnabled,
                  isNoTopBorderRadius: isTrafficVisable,
                  onParkingTap: () {
                    final autoEnableParking = ref.read(navigatorAutoEnableParkingProvider);

                    if (autoEnableParking == null) {
                      ref.read(parkingAutoenabledSheetProvider.notifier).showParkingAutoEnableSheet(value: true);
                      return;
                    }

                    final parkingEnabledFreeRoam =
                        sharedPrefs.getBool(MapnessConstants.parkingEnabledFreeRoam) ?? false;

                    if (layers.selectedType != LayerType.parkingLots && parkingEnabledFreeRoam == false) {
                      sharedPrefs.setBool(MapnessConstants.parkingEnabledFreeRoam, true);
                    }

                    layersNotifier.toggleParking();
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ParkingWidget extends StatelessWidget {
  final bool isEnabled;
  final bool isNoTopBorderRadius;
  final void Function() onParkingTap;

  const _ParkingWidget({
    required this.isEnabled,
    required this.onParkingTap,
    this.isNoTopBorderRadius = false,
  });

  @override
  Widget build(BuildContext context) => MapButton(
    semanticsLabel: context.l10n.layersParking,
    borderRadius: isNoTopBorderRadius
        ? const BorderRadius.only(
            bottomLeft: Radius.circular(RadiusBorder.ml),
            bottomRight: Radius.circular(RadiusBorder.ml),
          )
        : null,
    onTap: onParkingTap,
    child: SizedBox(
      width: 24,
      height: 24,
      child: Icon(
        TransportIcons.parkingEnable,
        color: isEnabled
            ? SaudiNationalDay.isNow()
                  ? context.colors.accentDefault
                  : context.colors.foregroundDefault
            : context.colors.foregroundDefault,
      ),
    ),
  );
}

class _TrafficControl extends StatelessWidget {
  final bool isEnabled;
  final bool isVisable;
  final TrafficState trafficState;
  final bool parkingVisible;

  const _TrafficControl({
    required this.isEnabled,
    required this.isVisable,
    required this.trafficState,
    required this.parkingVisible,
  });

  @override
  Widget build(
    BuildContext context,
  ) => TrafficControlWidget(
    opacity: isVisable ? 1 : 0,
    isEnabled: isEnabled,
    borderRadius: BorderRadius.only(
      topLeft: const Radius.circular(RadiusBorder.ml),
      topRight: const Radius.circular(RadiusBorder.ml),
      bottomRight: parkingVisible ? Radius.zero : const Radius.circular(RadiusBorder.ml),
      bottomLeft: parkingVisible ? Radius.zero : const Radius.circular(RadiusBorder.ml),
    ),
    onTap: () {
      trafficState.onTrafficTap();
    },
  );
}
