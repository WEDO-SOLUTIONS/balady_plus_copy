import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/icons/transport_icons.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/follow_state.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class FollowControl extends ConsumerWidget {
  const FollowControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followState = ref.watch(followStateProvider);
    final followNotifier = ref.watch(followStateProvider.notifier);
    final iconColor = followState.type == LocationFollowType.off ? NonThemeColor.color30 : AppColor.black;

    return MapButton(
      onTap: () async {
        Metrics.logEventAdvanced(
          MetricsConstants.exploreKeys.locateMeIcon,
          group: MetricsConstants.exploreTag,
          action: MetricAction.tap.name,
        );

        ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetircsKeys.exploreLandingEngagement);

        final location = ref.read(locationProvider.notifier);
        final result = await location.checkLocationPermission();

        if (result) {
          followNotifier.toggleFollowState();
        }
      },
      child: Icon(
        followState.type == LocationFollowType.followDirection
            ? TransportIcons.locationDirectionNavigator
            : TransportIcons.locationLTR,
        color: iconColor,
        size: 24,
      ),
    );
  }
}
