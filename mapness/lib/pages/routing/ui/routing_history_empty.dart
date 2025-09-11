import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class RoutingHistoryEmpty extends StatelessWidget {
  const RoutingHistoryEmpty({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            child: Text(
              context.l10n.selectYourStartingAndDestinationPointsAndWeWillShowYouConvenientRoutes,
              textAlign: TextAlign.center,
              style: context.textStyle.footNote.copyWith(color: context.colors.foregroundDefault),
            ),
          ),
        ),
      );
}
