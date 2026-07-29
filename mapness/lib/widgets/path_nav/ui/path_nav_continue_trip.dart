import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/path_nav/models/path_nav_eta.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

class PathNavContinueTrip extends StatelessWidget {
  const PathNavContinueTrip({
    required this.onPressed,
    required this.eta,
    super.key,
  });
  final PathNavEta? eta;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.accentOnContainer,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.continueTrip,
              style: context.textStyle.heading1.copyWith(color: Colors.white),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  eta == null ? '-' : context.digits(eta!.arrivalTime),
                  style: context.textStyle.caption.copyWith(
                    color: Colors.white.withOpacity(0.800000011920929),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 2,
                  height: 2,
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: OvalBorder(),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  eta == null ? '-' : context.digits(eta!.distanceEta),
                  style: context.textStyle.caption.copyWith(
                    color: Colors.white.withOpacity(0.800000011920929),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
