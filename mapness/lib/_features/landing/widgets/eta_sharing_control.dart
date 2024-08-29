import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/share_eta/providers/websocket_status_provider.dart';
import 'package:mapness/features/share_eta/ui/pulse_indicator.dart';

class EtaSharingControl extends ConsumerWidget {
  const EtaSharingControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webSocketStatus = ref.watch(websocketStatusProvider);

    final estimatedTime = webSocketStatus.estimatedTime;

    // substract estimated time from current time and status diff
    final diffTime = estimatedTime != null ? estimatedTime.difference(DateTime.now()) : null;

    // if diff have hours print hours then check minutes. If hours == 0 print only minutes
    final diffHours = diffTime != null ? diffTime.inHours : 0;
    final diffMinutes = diffTime != null ? diffTime.inMinutes.remainder(60) : 0;

    final estimatedTimeString = diffHours > 0 ? '$diffHours hr $diffMinutes min' : '$diffMinutes min';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: webSocketStatus.status
          ? MapButton(
              onTap: () {
                print('On tap');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const PulseIndicator(),
                    const SizedBox(width: 8),
                    Text(
                      estimatedTimeString,
                      style: context.textStyleV3.captionLargeMedium.copyWith(color: context.colorsV2.foregroundDefault),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
