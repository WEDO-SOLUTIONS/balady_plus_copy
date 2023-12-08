import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/path_nav/models/path_nav_eta.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PathNavContinueTrip extends StatelessWidget {
  final PathNavEta? eta;
  final VoidCallback onPressed;

  const PathNavContinueTrip({
    super.key,
    required this.onPressed,
    required this.eta,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xff4CA5B4),
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
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .headingS
                    .copyWith(color: Colors.white),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    eta?.arrivalTime ?? '-',
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textXS
                        .copyWith(
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
                    eta?.distanceEta ?? '-',
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textXS
                        .copyWith(
                          color: Colors.white.withOpacity(0.800000011920929),
                        ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
