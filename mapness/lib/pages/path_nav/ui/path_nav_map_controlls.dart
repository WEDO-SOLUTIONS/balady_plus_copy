import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/features/path_nav/providers/path_nav_maneuver.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/path_nav/providers/path_nav_speed_info.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_follow_control.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_maneuver_widget.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_message_widget.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_speed_info_widget.dart';

class PathNavMapControlls extends ConsumerWidget {
  final RouteSearchOptionsMessage navType;

  const PathNavMapControlls({required this.navType, super.key});
  final RouteSearchOptionsMessage navType;

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(appLanguageProvider) == Language.arabic;
    return Directionality(
      /// do not mirror map controls since most of people are right-handed
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// maneuver or message
                Consumer(
                  builder: (context, ref, child) {
                    final message = ref.watch(pathNavMessageProvider);
                    final maneuver = ref.watch(pathNavManeuverProvider);
                    if (message != null) {
                      return PathNavMessageWidget(message: message);
                    }
                    if (maneuver == null) {
                      return const SizedBox.shrink();
                    }
                    return PathNavManeuverWidget(
                      maneuver: maneuver,
                    );
                  },
                ),

                /// speed info
                if (navType == RouteSearchOptionsMessage.pedestrian)
                  const Spacer(),
                if (navType != RouteSearchOptionsMessage.pedestrian)
                  Consumer(
                    builder: (context, ref, child) {
                      final info = ref.watch(pathNavSpeedInfoProvider);
                      return PathNavSpeedInfoWidget(info: info);
                    },
                  ),
              ],
            ),
          ),

          /// map controls
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 12,
                  right: 12,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const LayersControl(),
                    const SizedBox(
                      height: 8,
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        final navi = ref.watch(appFeaturesProvider);
                        return Visibility(
                          visible: navi.naviEnabled,
                          replacement: const SizedBox.square(
                            dimension: 28,
                          ),
                          child: const TrafficControl(),
                        );
                      },
                    ),
                    const Spacer(),
                    const ZoomControl(),
                    const Spacer(),
                    const CompassControl(),
                    const SizedBox(
                      height: 8,
                    ),
                    const PathNavFollowControl(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
