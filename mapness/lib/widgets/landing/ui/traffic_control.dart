import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/map/traffic_state.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';
import 'package:mapness/widgets/landing/lib/traffic_state_event_color.dart';

class TrafficControl extends ConsumerWidget {
  const TrafficControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trafficState = ref.watch(trafficStateProvider);
    final trafficNotifier = ref.watch(trafficStateProvider.notifier);
    final color = trafficState.color;
    final textColor = trafficState.status == TrafficControlStatus.enabled
        ? Colors.white
        : const Color(0xff1E2A36);

    return AnimatedOpacity(
      opacity: trafficState.status == TrafficControlStatus.hidden ? 0 : 1,
      duration: const Duration(milliseconds: 250),
      child: MapButton(
        onTap: trafficNotifier.onTrafficTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: trafficState.status == TrafficControlStatus.enabled
                    ? color
                    : Colors.transparent,
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
            ),
            Text(
              trafficState.score.toString(),
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .accentM
                  .copyWith(
                    color: textColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
