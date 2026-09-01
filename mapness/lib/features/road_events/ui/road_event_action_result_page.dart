import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:sheetify/sheetify.dart';

/// Shown after a road-event action (`RoadEventActionType`) completes successfully
/// (e.g. "Still there" / "Not anymore"). Auto-closes after [_autoCloseDuration].
/// Stub content — layout to be filled in separately; [_countdownController] is
/// wired up for a future remaining-time indicator widget.
@RoutePage()
class RoadEventActionResultPage extends StatefulHookConsumerWidget {
  const RoadEventActionResultPage({required this.type, super.key});

  final RoadEventActionType type;

  @override
  ConsumerState<RoadEventActionResultPage> createState() => _RoadEventActionResultPageState();
}

class _RoadEventActionResultPageState extends ConsumerState<RoadEventActionResultPage>
    with SingleTickerProviderStateMixin {
  static const _autoCloseDuration = Duration(seconds: 5);

  // Counts down from 1.0 (just opened) to 0.0 (about to close) over
  // _autoCloseDuration — feed .value directly into a countdown-visual widget.
  late final AnimationController _countdownController;
  Timer? _autoCloseTimer;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _countdownController = AnimationController(vsync: this, duration: _autoCloseDuration)..reverse(from: 1);
    _autoCloseTimer = Timer(_autoCloseDuration, _close);
  }

  void _close() {
    if (_isClosing || !mounted) {
      return;
    }
    _isClosing = true;
    _autoCloseTimer?.cancel();
    context.router.pop();
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    _countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = useToggleSheetController(onClose: (controller) => _close());

    final iconAndColor = switch (widget.type) {
      RoadEventActionType.confirmation => (TransportIcons.accident, context.colors.errorDefault),
      RoadEventActionType.disproof => (SystemIcons.checkmark, context.colors.accentDefault),
    };

    final message = switch (widget.type) {
      RoadEventActionType.confirmation => context.l10n.roadEventStillThere,
      RoadEventActionType.disproof => context.l10n.roadEventNotAnymore,
    };

    return ToggleSheet(
      dragger: const SheetDragger(),
      backgroundColor: context.colors.backgroundSurface1,
      safeAreaColor: context.colors.backgroundSurface1,
      content: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: Spacing.$6x,
            left: Spacing.$4x,
            right: Spacing.$4x,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Spacing.$3x,
            children: [
              Container(
                height: 36,
                width: 36,
                margin: const EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  color: iconAndColor.$2,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconAndColor.$1,
                  color: context.colors.staticWhite,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Spacing.$1x,
                  children: [
                    Text(
                      message,
                      style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
                    ),
                    Text(
                      context.l10n.thanksForYourFeedback,
                      style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                    ),
                  ],
                ),
              ),
              CustomIconButtonWidget(
                btnHeight: 36,
                btnWidth: 36,
                iconSize: 24,
                borderRadius: 8.0,
                backgroundColor: context.colors.neutralContainerDefault,
                icon: SystemIcons.close,
                iconColor: context.colors.neutralOnContainer,
                onPressed: () => context.router.pop(),
              ),
            ],
          ),
        ),
      ],
      scrollController: scrollController,
    );
  }
}
