import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/cityscape/cityscape.dart';
import 'package:mapness/features/founding_day/founding_day.dart';
import 'package:mapness/features/leap/leap.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_background.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_config.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_logo.dart';
import 'package:sheetify/sheetify.dart';

/// Unified widget that displays event-specific UI based on the active event type
///
/// This widget automatically handles:
/// - Event background banner
/// - Event logo with animations
/// - Saudi National Day specific banner with text
/// - All event-specific interactions
class CityEventDisplay extends ConsumerWidget {
  final CityEventType? activeEvent;
  final MultiStateSheetController<ThreeStateSheet> controller;
  final AnimationController? fireworksController;

  const CityEventDisplay({required this.controller, this.activeEvent, this.fireworksController, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (activeEvent == null) {
      return const SizedBox.shrink();
    }

    final config = CityEventConfig.fromEventType(activeEvent);
    if (config == null) {
      return const SizedBox.shrink();
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      // The logo below is `Positioned` so it doesn't inflate this Stack's own
      // size, but a Positioned child is still clipped to that size by default
      // — allow it to paint past the banner's bounds instead of being cut off.
      clipBehavior: Clip.none,
      children: [
        CityEventBackground(
          controller: controller,
          config: config,
          onTap: () {
            if (activeEvent == CityEventType.cityscape) {
              ref.read(cityscapeProvider.notifier).openThePlace();
            } else if (activeEvent == CityEventType.leap) {
              ref.read(leapProvider.notifier).openThePlace();
            } else if (activeEvent == CityEventType.foundingDay) {
              fireworksController!
                ..value = 0
                ..animateTo(
                  fireworksController!.upperBound,
                  curve: Curves.easeOutQuint,
                  duration: fireworksController!.duration,
                );

              ref.read(foundingDayUrbiProvider.notifier).openThePlace();
            }
          },
        ),

        // Event logo (if configured). Wrapped in `Positioned` so it decorates
        // on top of the banner without counting toward this Stack's own size —
        // otherwise a logo taller than the banner (e.g. leap) inflates the
        // measured `topHeader` height and pushes the map control buttons up.
        if (config.hasLogo && config.logoConfig != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CityEventLogo(
              config: config.logoConfig!,
              fireworksController: fireworksController,
              onTap: () {
                if (activeEvent == CityEventType.cityscape) {
                  ref.read(cityscapeProvider.notifier).openThePlace();
                }
                if (activeEvent == CityEventType.leap) {
                  ref.read(leapProvider.notifier).openThePlace();
                }
                if (activeEvent == CityEventType.foundingDay) {
                  ref.read(foundingDayUrbiProvider.notifier).openThePlace();
                } else if (activeEvent == CityEventType.saudiNationalDay && fireworksController != null) {
                  // Fireworks are handled automatically in CityEventLogo
                }
              },
            ),
          ),
      ],
    );
  }
}
