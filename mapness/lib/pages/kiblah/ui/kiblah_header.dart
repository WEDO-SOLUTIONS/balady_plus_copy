import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/pages/kiblah/providers/kaaba_bearing.dart';
import 'package:mapness/pages/kiblah/providers/kaaba_haptics.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/compass.dart';

class KiblahHeader extends ConsumerWidget {
  const KiblahHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(kaabaHapticsProvider);

    final kaabaBearing = ref.watch(kaabaBearingProvider);
    final userBearing = ref.watch(compassProvider);
    final bearingDiff = kaabaBearing.floor() - userBearing.floor();

    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        left: 12,
        right: 12,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    ref.read(mapControlsProvider.notifier).update(
                          MapControlsStateDashboard(),
                        );
                    const LandingRoute().go(context);
                  },
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 48),
                    height: 48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/svg/ic_chevron_right.svg',
                          height: 24,
                          width: 24,
                          package: PackageConfig.packageName,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF1E2A36),
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            context.l10n.kiblahBearingDiff
                .replaceFirst('%degrees', '$bearingDiff'),
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .textL
                .copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}
