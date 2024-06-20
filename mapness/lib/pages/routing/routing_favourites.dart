import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

class RoutingFavouritesPage extends ConsumerWidget {
  const RoutingFavouritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 7.5,
                    bottom: 8.5,
                    left: 16,
                    right: 16,
                  ),
                  child: Text(
                    context.l10n.favourites,
                    style: context.textStyle.callout.copyWith(color: Colors.white),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Metrics.logEventAdvanced(
                          MetricsConstants.routesKeys.favoriteBack,
                          group: MetricsConstants.routesTag,
                          action: MetricAction.tap.toString(),
                        );

                        context.pop(null);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          'assets/icons/svg/ic_chevron_right.svg',
                          height: 24,
                          width: 24,
                          package: PackageConfig.packageName,
                          colorFilter: ColorFilter.mode(
                            context.color.textAndIconsBasePrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
