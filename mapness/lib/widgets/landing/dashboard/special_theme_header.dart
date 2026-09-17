import 'dart:ui';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart' as balady_ctx;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/makkah_places/makkah_places_layer_provider.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/features/special_themes/modes/mekkah_base/makkah_poi_constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/widgets/landing/dashboard/national_flag.dart';
import 'package:sheetify/sheetify.dart';

/// Header overlays (banner + flag) for special dashboard themes.
///
/// Used by [MapHiddenStateControls] to render event-specific UI above
/// the quick search bar, without hard-coding per-event logic there.

class SpecialThemeHeader extends ConsumerWidget {
  const SpecialThemeHeader({
    required this.mode,
    required this.controller,
    required this.fireworksController,
    super.key,
  });

  final SpecialThemeMode mode;
  final MultiStateSheetController<ThreeStateSheet> controller;
  final AnimationController fireworksController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
    final banner = _buildBanner(context, isDark: isDark);
    final flag = _buildFlag();

    if (banner == null && flag == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [if (banner != null) banner, if (flag != null) flag],
    );
  }

  Widget? _buildBanner(BuildContext context, {required bool isDark}) {
    final bool hasBanner =
        mode == SpecialThemeMode.nationalDay || mode == SpecialThemeMode.mekkahBase || mode == SpecialThemeMode.ramadan;
    if (!hasBanner) return null;

    final BoxDecoration bannerDecoration;
    if (mode == SpecialThemeMode.mekkahBase) {
      if (isDark) {
        bannerDecoration = BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(RadiusBorder.xl),
          ),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              MakkahPoiConstants.darkAccentTeal,
              Color(0xFF007B73),
              Color(0xFF00232F),
            ],
            stops: [0.0, 0.53, 1.0],
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/themes/makkah/ribbon_pattern_dark.webp'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
            opacity: 0.2,
          ),
        );
      } else {
        bannerDecoration = BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(RadiusBorder.xl),
          ),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFD19D3F),
              Color(0xFF9D6808),
              Color(0xFFFFCA69),
              Color(0xFFD19D3F),
              Color(0xFFD19D3F),
            ],
            stops: [0.03, 0.19, 0.33, 0.46, 1.0],
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/themes/makkah/qiblah_header.webp'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
            opacity: 0.5,
          ),
        );
      }
    } else if (mode == SpecialThemeMode.ramadan) {
      bannerDecoration = BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(RadiusBorder.xl),
        ),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF32454C),
            Color(0xFF98C5C8),
            Color(0xFF50646C),
            Color(0xFF32454C),
            Color(0xFF32454C),
            Color(0xFF50646C),
            Color(0xFF32454C),
          ],
          stops: [0.03, 0.21, 0.42, 0.54, 0.69, 0.91, 1.0],
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/themes/ramadan/ramadan_header.webp'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          opacity: 0.5,
        ),
      );
    } else {
      bannerDecoration = const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusBorder.xl),
        ),
        color: Color(0xFF00343A),
      );
    }

    return MultiStateSheetBuilder<ThreeStateSheet>(
      defaultState: ThreeStateSheet.hidden,
      builder: (context, state, interpolation, child) => Padding(
        padding: EdgeInsets.only(
          top: state == ThreeStateSheet.hidden ? Spacing.$4x * (1 - interpolation) : 0,
        ),
        child: GestureDetector(
          onTap: () => controller.setState(ThreeStateSheet.open),
          child: SizedBox(
            height: Spacing.$12x * (state == ThreeStateSheet.hidden ? clampDouble(interpolation * 3, 0, 1) : 1.0),
            width: double.infinity,
            child: DecoratedBox(
              decoration: bannerDecoration,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: Spacing.$4x,
                    bottom: Spacing.$4x,
                  ),
                  child: _buildBannerText(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerText(BuildContext context) {
    if (mode == SpecialThemeMode.nationalDay) {
      return Text(
        context.l10n.happy95thYears,
        style:
            balady_ctx.BuildContextExt(
              context,
            ).textStyles.bodySmallSemiBold.copyWith(
              color: balady_ctx.BuildContextExt(context).colors.successOnSuccess,
            ),
        textAlign: TextAlign.center,
      );
    }

    if (mode == SpecialThemeMode.ramadan) {
      return Text(
        context.l10n.ramadanDateRange('18 Feb', '19 Mar 2026'),
        style:
            balady_ctx.BuildContextExt(
              context,
            ).textStyles.bodySmallSemiBold.copyWith(
              color: balady_ctx.BuildContextExt(context).colors.successOnSuccess,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      );
    }

    return const SizedBox.shrink();
  }

  Widget? _buildFlag() {
    if (mode == SpecialThemeMode.nationalDay) {
      return NationalFlag(
        onTap: () {
          fireworksController
            ..value = 0
            ..animateTo(
              fireworksController.upperBound,
              curve: Curves.easeOutQuint,
              duration: fireworksController.duration,
            );
        },
      );
    }

    if (mode == SpecialThemeMode.mekkahBase) {
      return const _MekkahQiblahIcon();
    }

    if (mode == SpecialThemeMode.ramadan) {
      return _RamadanIcon(
        onTap: () {
          fireworksController
            ..value = 0
            ..animateTo(
              fireworksController.upperBound,
              curve: Curves.easeOutQuint,
              duration: fireworksController.duration,
            );
        },
      );
    }

    return null;
  }
}

class _MekkahQiblahIcon extends ConsumerStatefulWidget {
  const _MekkahQiblahIcon({this.onTap});

  final VoidCallback? onTap;

  @override
  ConsumerState<_MekkahQiblahIcon> createState() => _MekkahQiblahIconState();
}

class _MekkahQiblahIconState extends ConsumerState<_MekkahQiblahIcon> with SingleTickerProviderStateMixin {
  late final AnimationController scaleController = AnimationController(
    vsync: this,
    duration: Durations.medium1,
  );

  @override
  void dispose() {
    scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Track header icon tap
    Metrics.logEventAdvanced(
      MetricsConstants.themesKeys.headerIconTapped,
      group: MetricsConstants.themesTag,
      action: MetricAction.tap.name,
      props: {'theme': 'mekkahBase', 'icon': 'qiblah'},
    );

    scaleController
      ..value = 0
      ..animateTo(1, curve: Curves.easeOut);
    widget.onTap?.call();
    // Fly camera to show all Makkah places
    ref.read(makkahPlacesLayerProvider.notifier).flyToAllPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final qiblahIcon = Image.asset(
      'assets/images/themes/makkah/qiblah_icon.webp',
      width: MediaQuery.sizeOf(context).width * 0.35,
    );

    return MultiStateSheetBuilder<ThreeStateSheet>(
      defaultState: ThreeStateSheet.hidden,
      builder: (context, state, interpolation, child) {
        final delta = state == ThreeStateSheet.hidden ? clampDouble(interpolation * 3, 0, 1) : 1.0;
        return IgnorePointer(
          ignoring: state == ThreeStateSheet.hidden,
          child: Align(
            heightFactor: delta,
            alignment: Alignment.topCenter,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: _handleTap,
        onTapDown: (_) => scaleController
          ..value = 0
          ..animateTo(.4, curve: Curves.easeOut),
        onLongPressEnd: (_) {
          scaleController.animateTo(1, curve: Curves.easeOut);
          _handleTap();
        },
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: Spacing.$6x,
              bottom: Spacing.$1_5x,
            ),
            child: ScaleTransition(
              scale: Tween<double>(
                begin: .9,
                end: 1.0,
              ).animate(scaleController),
              child: qiblahIcon,
            ),
          ),
        ),
      ),
    );
  }
}

class _RamadanIcon extends ConsumerStatefulWidget {
  const _RamadanIcon({this.onTap});

  final VoidCallback? onTap;

  @override
  ConsumerState<_RamadanIcon> createState() => _RamadanIconState();
}

class _RamadanIconState extends ConsumerState<_RamadanIcon> with SingleTickerProviderStateMixin {
  late final AnimationController scaleController = AnimationController(
    vsync: this,
    duration: Durations.medium1,
  );

  @override
  void dispose() {
    scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Track header icon tap
    Metrics.logEventAdvanced(
      MetricsConstants.themesKeys.headerIconTapped,
      group: MetricsConstants.themesTag,
      action: MetricAction.tap.name,
      props: {'theme': 'ramadan', 'icon': 'ramadan'},
    );

    scaleController
      ..value = 0
      ..animateTo(1, curve: Curves.easeOut);
    widget.onTap?.call();
    // Fly camera to show all Makkah places
    ref.read(makkahPlacesLayerProvider.notifier).flyToAllPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final ramadanIcon = Image.asset(
      'assets/images/themes/ramadan/ramadan_icon.webp',
      width: MediaQuery.sizeOf(context).width * 0.35,
    );

    return MultiStateSheetBuilder<ThreeStateSheet>(
      defaultState: ThreeStateSheet.hidden,
      builder: (context, state, interpolation, child) {
        final delta = state == ThreeStateSheet.hidden ? clampDouble(interpolation * 3, 0, 1) : 1.0;
        return IgnorePointer(
          ignoring: state == ThreeStateSheet.hidden,
          child: Align(
            heightFactor: delta,
            alignment: Alignment.topCenter,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: _handleTap,
        onTapDown: (_) => scaleController
          ..value = 0
          ..animateTo(.4, curve: Curves.easeOut),
        onLongPressEnd: (_) {
          scaleController.animateTo(1, curve: Curves.easeOut);
          _handleTap();
        },
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: Spacing.$6x,
              bottom: Spacing.$1_5x,
            ),
            child: ScaleTransition(
              scale: Tween<double>(
                begin: .9,
                end: 1.0,
              ).animate(scaleController),
              child: ramadanIcon,
            ),
          ),
        ),
      ),
    );
  }
}
