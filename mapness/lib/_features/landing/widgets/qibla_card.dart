import 'dart:math';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/kiblah.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';

class QiblaCard extends ConsumerWidget {
  const QiblaCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GestureDetector(
          onTap: () async {
            Metrics.logEventAdvanced(
              MetricsConstants.exploreKeys.qibla,
              action: MetricAction.tap.name,
              group: MetricsConstants.exploreTag,
            );
            final location = ref.read(locationProvider.notifier);

            await location.checkLocationPermission().then((allowed) {
              if (allowed) {
                const KiblahRoute().push(context);
              }
            });
          },
          child: SizedBox(
            height: 118,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF525252), Color(0xFF1B1B1B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
                        child: Text(
                          context.l10n.qibla,
                          style: context.textStyleV3.h2Medium.copyWith(
                            color: context.colorsV2.staticWhite,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                        child: Text(
                          context.l10n.showDirection,
                          style: context.textStyleV3.captionLargeRegular.copyWith(
                            color: context.colorsV2.staticWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: context.isLTR ? Matrix4.identity() : Matrix4.rotationY(pi),
                      child: Image.asset(
                        'assets/images/qibla.png',
                        package: PackageConfig.packageName,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
