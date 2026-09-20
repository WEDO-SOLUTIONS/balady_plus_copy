import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/balady_analytics/events/tifo_events.dart';
import 'package:mapness/features/tifo/team_select_screen.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

/// Direct entry points into TIFO screens that normally sit behind a gate.
///
/// `TifoJourney` only reaches the team picker after login, profile load and
/// `ensurePlayReady`, which makes the screen itself hard to iterate on. These
/// buttons push the widget straight onto the root navigator: no auth, no
/// journey step checks. The screen still loads the roster from the backend, so
/// the identity/base URL set in the TIFO Backend panel above still applies.
class TifoScreensDebugPanel extends StatelessWidget {
  const TifoScreensDebugPanel({required this.draggableController, super.key});

  final DraggableScrollableController draggableController;

  @override
  Widget build(BuildContext context) => DebugCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DebugSectionHeader(
          icon: Icons.sports_soccer_rounded,
          title: 'TIFO Screens',
          subtitle: 'Open directly — skips login and journey checks',
          gradient: DebugTheme.gradientTeal,
        ),
        const SizedBox(height: 14),
        DebugButton(
          label: 'Choose your team',
          icon: Icons.groups_rounded,
          gradient: DebugTheme.gradientTeal,
          onPressed: _openTeamSelect,
        ),
      ],
    ),
  );

  void _openTeamSelect() {
    final navigator = rootNavigatorKey.currentState;
    if (navigator == null) {
      return;
    }
    // The debug overlay lives in the root overlay, above every route, so the
    // sheet has to get out of the way or it covers the screen we just pushed.
    draggableController.animateTo(
      0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.linear,
    );
    unawaited(
      navigator
          .push<bool>(
            MaterialPageRoute<bool>(
              fullscreenDialog: true,
              builder: (_) => const TifoTeamSelectScreen(
                source: TifoActivationSource.banner,
              ),
            ),
          )
          .then((result) => logger.log('[tifo][debug] team select popped: $result')),
    );
  }
}
