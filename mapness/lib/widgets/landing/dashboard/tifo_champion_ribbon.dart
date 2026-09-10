import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/tifo/tifo_champion_ribbon_config.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_background.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_config.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_logo.dart';
import 'package:sheetify/sheetify.dart';

/// TIFO "champions of the month" ribbon (Figma `dashboard_ribbon03`).
///
/// Shares the city events' banner slot and their shell — [CityEventBackground]
/// for the body, [CityEventLogo] for the trophy — so it behaves identically to
/// the WRC and Cityscape banners under the sheet's drag interpolation.
///
/// The trophy stands taller than the ribbon and is meant to overhang it. It is
/// therefore `Positioned`, which keeps it out of this Stack's measured size:
/// otherwise the dashboard would read the ribbon as that much taller and push
/// the map control buttons up, which is exactly what happens if the trophy is
/// laid out as a normal child.
class TifoChampionRibbon extends StatelessWidget {
  const TifoChampionRibbon({
    required this.config,
    required this.controller,
    super.key,
    this.confettiController,
  });

  final TifoChampionRibbonConfig config;
  final MultiStateSheetController<ThreeStateSheet> controller;

  /// The dashboard's shared confetti animation, fired by a tap on the ribbon.
  /// The same controller drives Founding Day's fireworks.
  final AnimationController? confettiController;

  void _celebrate() {
    final controller = confettiController;
    if (controller == null) {
      return;
    }
    controller
      ..value = 0
      ..animateTo(controller.upperBound, curve: Curves.easeOutQuint, duration: controller.duration);
  }

  @override
  Widget build(BuildContext context) {
    final eventConfig = _ChampionRibbonConfig(config, Localizations.localeOf(context));
    return Stack(
      alignment: Alignment.bottomCenter,
      // Let the trophy paint past the banner's bounds instead of being cut off.
      clipBehavior: Clip.none,
      children: [
        CityEventBackground(controller: controller, config: eventConfig, onTap: _celebrate),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CityEventLogo(config: eventConfig.logoConfig, onTap: _celebrate),
        ),
      ],
    );
  }
}

/// Adapts the Remote Config payload to the banner shell's contract.
class _ChampionRibbonConfig extends CityEventConfig {
  const _ChampionRibbonConfig(this.ribbon, this.locale);

  final TifoChampionRibbonConfig ribbon;

  /// Held rather than read from a `BuildContext` because [getText] is handed
  /// only an [AppLocalizations], and the month has to be named in the reader's
  /// language.
  final Locale locale;

  @override
  Color getBackgroundColor(BuildContext context) => ribbon.color;

  @override
  String getText(AppLocalizations l10n) => l10n.tifoChampionRibbon(
    _isolate(ribbon.teamName),
    _isolate(ribbon.monthName(locale)),
    _isolate(ribbon.year.toString()),
  );

  /// Wraps a substituted value in Unicode bidi isolates.
  ///
  /// The sentence mixes three directional runs — an Arabic template, a team
  /// name that is usually Latin, and Western digits. Left bare, the bidi
  /// algorithm resolves the neutral characters between them by context, and
  /// the dash and the exclamation mark migrate to the wrong end of the line.
  /// FSI…PDI makes each value a self-contained run, so the template's own
  /// order survives whatever the backend sends.
  static String _isolate(String value) => '\u2068$value\u2069';

  /// Confetti drifting over whatever colour Remote Config sends.
  ///
  /// Their teal-and-navy palette is baked into the artwork, so it reads as
  /// intended over the design's dark body and will fight a very light or very
  /// warm `color`. Worth knowing before the backend starts tinting the ribbon
  /// per winning team.
  @override
  Widget backgroundOverlay(BuildContext context) => const _DriftingConfetti();

  /// The ribbon is one finished sentence — no wordmark tacked on after it.
  @override
  String? get trailingWordmark => null;

  /// Flush with the top of its box: the 10 the other banners nudge down by
  /// reads as a gap between the ribbon and the map controls above it.
  @override
  double get verticalOffset => 0;

  /// Claims only the band that is actually seen. Trimming this shortens the
  /// ribbon from the TOP: its bottom is pinned to the sheet.
  @override
  double get bannerBoxHeight => 26;

  /// Drawn taller than that band so the body carries on under the sheet
  /// instead of ending at its edge, which read as the ribbon being sliced off.
  @override
  double get bannerDrawHeight => 48;

  /// Pulled up out of the middle of the drawn body: with 22 of the 48 hidden
  /// under the sheet, the default -0.2 would centre the text on a strip that
  /// is largely not on screen. Sits a little above the visible band's own
  /// centre, which the trophy beside it reads better against.
  @override
  Alignment get textAlignment => const Alignment(1, -0.58);

  @override
  bool get hasLogo => true;

  /// How far the trophy is pushed down from where the banner shell would
  /// otherwise put it.
  ///
  /// The shell draws the ribbon *below* its own box — `verticalOffset` plus an
  /// inner height taller than the outer one — so a logo pinned to the stack's
  /// bottom lands at the ribbon's TOP edge, floating clear of it. This is the
  /// single knob that seats the trophy back into the ribbon; raise it to sink
  /// the trophy further, lower it to lift the trophy up.
  static const double _trophyDrop = 12;

  @override
  EventLogoConfig get logoConfig => EventLogoConfig(
    imagePath: Assets.tifo.images.championTrophy.keyName,
    // Height follows from the artwork's own 0.41 aspect.
    width: 24,
    padding: const EdgeInsets.only(left: 40),
    imageOffset: const Offset(0, _trophyDrop),
    // The trophy is a still object; a sweeping highlight over it reads as a
    // glitch rather than a shine.
    hasShimmer: false,
  );
}

/// The ribbon's confetti, drifting diagonally for as long as the ribbon is up.
///
/// Tiled and wrapped rather than scrolled: four copies of the artwork sit on a
/// grid one tile apart, and the whole grid is offset by a distance taken
/// modulo the tile. Because the grid is periodic in both axes, a wrap moves it
/// by exactly one period and is therefore invisible — which is what lets the
/// drift run forever without a seam, and lets the two axes travel at unrelated
/// speeds instead of being locked to the artwork's own 5.8:1 aspect (a single
/// scrolling copy could only ever slide along that shallow diagonal).
///
/// The banner clips this, so the flecks never escape the ribbon.
class _DriftingConfetti extends StatefulWidget {
  const _DriftingConfetti();

  /// One horizontal pass of the pattern.
  static const Duration _period = Duration(seconds: 14);

  /// Vertical periods travelled per horizontal one. Raising it steepens the
  /// diagonal; the artwork being far wider than it is tall means a value of 1
  /// would read as sideways drift rather than falling confetti.
  static const double _verticalPasses = 4;

  /// The artwork's own aspect (393 x 68), used to keep the tile undistorted.
  static const double _artworkAspect = 393 / 68;

  @override
  State<_DriftingConfetti> createState() => _DriftingConfettiState();
}

class _DriftingConfettiState extends State<_DriftingConfetti> with SingleTickerProviderStateMixin {
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: _DriftingConfetti._period,
  )..repeat();

  @override
  void dispose() {
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Honour the platform's reduce-motion setting: the confetti stays, it
    // just stops moving.
    final still = MediaQuery.disableAnimationsOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        // One tile spans the banner's width, so the pattern never visibly
        // repeats across it; its height follows the artwork's aspect, which
        // leaves the tile taller than the banner and the flecks undistorted.
        final tileWidth = constraints.maxWidth;
        final tileHeight = tileWidth / _DriftingConfetti._artworkAspect;
        final tile = SizedBox(
          width: tileWidth,
          height: tileHeight,
          child: Assets.tifo.images.championRibbonConfetti.svg(fit: BoxFit.fill),
        );

        // Rows sit half a tile apart, so each one's sparse top and bottom
        // margins are covered by its neighbour's dense middle. Spacing them a
        // full tile apart left those two margins meeting at the seam, and the
        // combined empty band swept across the ribbon once per pass.
        //
        // Halving the spacing halves the vertical period too, and a wrap by
        // one period stays invisible — so this costs nothing but overlap. It
        // is done vertically only: the same trick across the width would make
        // the pattern repeat twice within the visible ribbon, which reads as a
        // mirrored copy rather than more confetti.
        final rowStep = tileHeight / 2;

        return AnimatedBuilder(
          animation: _drift,
          builder: (context, _) {
            final phase = still ? 0.0 : _drift.value;
            final dx = phase * tileWidth % tileWidth;
            final dy = phase * tileHeight * _DriftingConfetti._verticalPasses % rowStep;
            return Stack(
              children: [
                // The grid runs from one step back so the leading edge is
                // always covered as the offset grows.
                for (var column = -1; column <= 0; column++)
                  for (var row = -1; row <= 0; row++)
                    Transform.translate(
                      offset: Offset(dx + column * tileWidth, dy + row * rowStep),
                      child: tile,
                    ),
              ],
            );
          },
        );
      },
    );
  }
}
