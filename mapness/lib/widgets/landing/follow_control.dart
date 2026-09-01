import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/icons/transport_icons.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message_state.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/follow_state.dart';
import 'package:mapness/shared/providers/map/navigation_controls_visibility.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class FollowControl extends ConsumerWidget {
  const FollowControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLTR = ref.watch(appLanguageProvider) != Language.arabic;
    final followState = ref.watch(followStateProvider);
    final followNotifier = ref.watch(followStateProvider.notifier);
    final hasGPS = ref.watch(pathNavMessageProvider)?.state != PathNavMessageState.gpsConnectionLost;

    final iconColor = followState.type == LocationFollowType.off
        ? context.colors.foregroundDefault
        : context.colors.accentDefault;

    return MapButton(
      semanticsLabel: context.l10n.myLocation,
      onTap: () async {
        ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingEngagement);
        ref.read(navigationControlsVisibilityProvider.notifier).registerInteraction();

        final location = ref.read(locationProvider.notifier);
        final result = await location.checkLocationPermission();

        if (result) {
          followNotifier.toggleFollowState();
        }
      },
      child: Icon(
        hasGPS
            ? (followState.type == LocationFollowType.followDirection
                  ? TransportIcons.locationDirection
                  : (isLTR ? TransportIcons.locationFullLTR : TransportIcons.locationFullRTL))
            : (isLTR ? TransportIcons.locationQuestionLTR : TransportIcons.locationQuestionRTL),
        color: iconColor,
        size: 24,
      ),
    );
  }
}
