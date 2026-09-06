import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/lib/ar_functions.dart';

/// TIFO design tokens, pulled from the Figma variables (`accent/*`,
/// `neutral/*`, `English/*` type ramp). The design font is "Golos Text" — not
/// bundled in the app yet, so styles fall back to the default family with the
/// correct size/weight/height. Add the font later for pixel-parity.
abstract final class TifoColors {
  static const Color accent = Color(0xFF1B8354); // accent/default
  static const Color accentSoft = Color(0xFF25935F); // accent/soft
  static const Color accentMuted = Color(0xFF54C08A); // accent/muted
  static const Color accentContainer = Color(0x1A25935F); // accent/container-default (~10%)
  static const Color onAccent = Color(0xFFFFFFFF);

  static const Color surface = Color(0xFFFFFFFF); // background/surface1
  static const Color textDefault = Color(0xFF161616); // Text/text-default
  static const Color textStrong = Color(0xFF1B1B1B); // foreground/default
  static const Color textSoft = Color(0xFF9DA4AE); // neutral/foreground-soft
  static const Color border = Color(0xFFE7EAEE);
  static const Color amber = Color(0xFFD9A400);

  /// Penalty-preview field — the deep green the design paints the whole
  /// "Game preview" screen with, in light and dark alike (Figma `App` frame).
  static const Color penaltyField = Color(0xFF0C3330);

  /// Score green on the preview's "Claim the building" card.
  static const Color accentBright = Color(0xFF17B26A);

  /// Token-cost amber: border/label, the big numeral, and its 10% wash.
  static const Color warn = Color(0xFFF79009);
  static const Color warnStrong = Color(0xFFFDB022);
  static const Color warnWash = Color(0x1AF79009);

  /// Fallback fill for a neutral / unowned entity.
  static const Color neutralFill = Color(0xFFFCFBF2);

  /// Miss-cross red — the design system's `error/default`. Pinned as a
  /// constant rather than read from `context.colors`: the penalty HUD renders
  /// inside the game's own `MaterialApp`, which carries no color extension.
  static const Color miss = Color(0xFFE0373D);
}

abstract final class TifoRadii {
  static const double m = 8;
  static const double ml = 10;
  static const double l = 16;
  static const double xxl = 24;
  static const double full = 999;
}

abstract final class TifoSpacing {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x6 = 24;
}

/// Type ramp (`English/*` in Figma). Font is intentionally NOT set here —
/// these styles inherit `fontFamily`/`package` from the ambient [ThemeData]
/// (`entry_point.dart`'s `_fontFamily()`), which already swaps "Golos"
/// (English, `balady_uikit`) for "IBM Plex Sans Arabic"
/// (`balady_design_system`) based on the active app language. Hardcoding
/// Golos here would keep TIFO on a Latin-only font even in Arabic. The
/// isolated `PenaltyApp`/`MaterialApp` (the Flame game) mirrors the same
/// switch in its own `theme.fontFamily` so this still resolves correctly
/// there.
abstract final class TifoText {
  static const TextStyle h1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w500,
    height: 1.1,
    color: TifoColors.textDefault,
  );
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: TifoColors.textDefault,
  );
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: TifoColors.textDefault,
  );
  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.1,
    color: TifoColors.textDefault,
  );
  static const TextStyle bodyL = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.25,
    color: TifoColors.textDefault,
  );
  static const TextStyle bodyLSemi = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: TifoColors.textDefault,
  );
  static const TextStyle bodyMSemi = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: TifoColors.textDefault,
  );
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: TifoColors.onAccent,
  );
  static const TextStyle captionRegular = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 14 / 11,
    color: TifoColors.textSoft,
  );
  static const TextStyle captionMedium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 14 / 11,
    color: TifoColors.textSoft,
  );
  static const TextStyle overline = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: TifoColors.accent,
  );
}

/// Readable text color for a filled swatch — dark ink on light team colors
/// (Yellow/Sand), white on dark ones (Blue/Black/Red).
Color tifoInkOn(Color background) => background.computeLuminance() > 0.6 ? TifoColors.textStrong : Colors.white;

/// Full-width primary CTA (green, radius 16, white label) matching every
/// "Dominate with your team" / "Confirm Team" / "START" button in the design.
class TifoPrimaryButton extends StatelessWidget {
  const TifoPrimaryButton({
    required this.label,
    super.key,
    this.onPressed,
    this.busy = false,
    this.leadingEmoji,
    this.trailingArrow = false,
    this.color = TifoColors.accent,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final String? leadingEmoji;
  final bool trailingArrow;
  final Color color;

  /// Green glow under the CTA (design `Button` node 398:8792:
  /// `0 4 10 rgba(22,163,74,0.3)`).
  static const BoxShadow _glow = BoxShadow(color: Color(0x4D16A34A), offset: Offset(0, 4), blurRadius: 10);

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TifoRadii.l),
          boxShadow: enabled ? const [_glow] : const [],
        ),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(TifoRadii.l),
          child: InkWell(
            borderRadius: BorderRadius.circular(TifoRadii.l),
            onTap: enabled ? onPressed : null,
            child: SizedBox(
              height: 48,
              child: Center(
                child: busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (leadingEmoji != null) ...[
                            Text(leadingEmoji!, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                          ],
                          Text(label, style: TifoText.button),
                          if (trailingArrow) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 16, color: TifoColors.onAccent),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Neutral filled pill button ("Exit" / "Leave" / "Continue") — the
/// non-primary half of a two-button message-card action row.
class TifoSecondaryButton extends StatelessWidget {
  const TifoSecondaryButton({required this.label, super.key, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.neutralContainerDefault,
    borderRadius: BorderRadius.circular(TifoRadii.l),
    child: InkWell(
      borderRadius: BorderRadius.circular(TifoRadii.l),
      onTap: onPressed,
      child: SizedBox(
        height: 48,
        child: Center(
          child: Text(label, style: TifoText.bodyLSemi.copyWith(color: context.colors.foregroundDefault)),
        ),
      ),
    ),
  );
}

/// "Maybe Later" style ghost button.
class TifoGhostButton extends StatelessWidget {
  const TifoGhostButton({required this.label, super.key, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    child: Text(label, style: TifoText.captionMedium.copyWith(fontSize: 14, color: TifoColors.textSoft)),
  );
}

/// `intl`'s NumberFormat doesn't map to Eastern Arabic-Indic digits for the
/// `ar` locale in this project's pinned version — render them manually so
/// "STEP 1 OF 2" reads "الخطوة ١ من ٢" instead of keeping Western digits.
/// "Since N day(s) ago" — Arabic day counts need the full 0/1/2/few/many/other
/// plural set (see [getPluralForAr]), not just singular/plural.
///
/// TIFO deliberately DIVERGES from [ArPlurals] here on two points, both by
/// product decision:
///
///  * every branch prepends the number, including 0/1/2. [ArPlurals.stations]
///    and `.transfers` bake those three counts into the word instead (`محطتان`
///    already means "two stations", so `2 محطتان` would read as "2 two
///    stations") — TIFO wants a visible numeral on every counter, so its
///    translations carry the bare noun and the numeral is always added here;
///  * digits stay Western (`3`) in Arabic too, not Eastern Arabic-Indic (`٣`).
///
/// So do not "restore" the 0/1/2 special-casing to match `ArPlurals`: it would
/// double the count in the string for this feature's translations.
String tifoStandingDaysAgo(BuildContext context, int days) {
  final l10n = AppLocalizations.of(context);
  return switch (getPluralForAr(days)) {
    Plurals.zero => '$days ${l10n.tifoStandingDaysZero}',
    Plurals.one => '$days ${l10n.tifoStandingDaysOne}',
    Plurals.two => '$days ${l10n.tifoStandingDaysTwo}',
    Plurals.few => '$days ${l10n.tifoStandingDaysFew}',
    Plurals.many => '$days ${l10n.tifoStandingDaysMany}',
    Plurals.others => '$days ${l10n.tifoStandingDaysOther}',
  };
}

/// Onboarding step header: back chevron + "STEP n OF m" + title + a segmented
/// progress bar (`filled` of `total` segments in accent).
class TifoStepHeader extends StatelessWidget {
  const TifoStepHeader({
    required this.step,
    required this.total,
    required this.title,
    super.key,
    this.onBack,
  });

  final int step;
  final int total;
  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (onBack != null) _CircleIconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack!),
              if (onBack != null) const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(
                      context,
                    ).stepOfTotal(step, total),
                    style: TifoText.overline,
                  ),
                  const SizedBox(height: 2),
                  Text(title, style: TifoText.h3.copyWith(color: context.colors.foregroundDefault)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (var i = 1; i <= total; i++) ...[
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= step ? TifoColors.accent : TifoColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                if (i < total) const SizedBox(width: 6),
              ],
            ],
          ),
        ],
      ),
    ),
  );
}

/// Green info banner (accent-container bg) with an icon + title + subtitle —
/// the season-lock / hint banners across the design.
class TifoInfoBanner extends StatelessWidget {
  const TifoInfoBanner({required this.icon, required this.title, super.key, this.subtitle});

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: TifoColors.accentContainer,
      borderRadius: BorderRadius.circular(TifoRadii.ml),
      border: Border.all(color: TifoColors.accentMuted.withValues(alpha: 0.4)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: TifoColors.accentSoft),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TifoText.bodyLSemi.copyWith(fontSize: 14, color: context.colors.foregroundDefault)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: TifoText.captionRegular),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.neutralContainerDefault,
    shape: CircleBorder(side: BorderSide(color: context.colors.neutralContainerDefault)),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(width: 36, height: 36, child: Icon(icon, size: 16, color: context.colors.neutralOnContainer)),
    ),
  );
}

/// The game's ball mark — the 3D render supplied by design, used everywhere a
/// ball is shown (map control, CTA rows, penalty HUD) instead of Material's
/// `Icons.sports_soccer_rounded` or the ⚽ emoji, which never matched it.
///
/// The artwork is black-and-white, so it is NOT tinted: on the green active
/// control it reads as the ball itself, not as a monochrome glyph.
class TifoBallIcon extends StatelessWidget {
  const TifoBallIcon({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    // Mirrors how Icon behaves under TIGHT constraints (map buttons hand the
    // child a fixed 46x46 through Material/InkWell): without the Center the
    // image is forced to the full box and the ball bleeds past the button's
    // rounded corners. Center re-loosens the constraints so [size] wins.
    child: Center(
      child: Image.asset(
        'assets/tifo/images/ball.png',
        package: 'mapness',
        width: size,
        height: size,
        fit: BoxFit.contain,
        // Falls back to the Material glyph if the asset is ever missing from a
        // build — a bare exception box in a map control would be worse.
        errorBuilder: (_, _, _) => Icon(Icons.sports_soccer_rounded, size: size, color: TifoColors.accent),
      ),
    ),
  );
}

/// A spent attempt in the penalty HUD (and its tutorial replica).
///
/// Was a ❌ emoji, and an emoji's glyph is chosen by FONT FALLBACK from the
/// ambient family: under the Arabic face the chain resolved to a monochrome
/// cross — white on the dark HUD — while under Golos it resolved to the color
/// one, so the same screen looked different per language. An icon with an
/// explicit color renders identically in every locale.
class TifoMissMark extends StatelessWidget {
  const TifoMissMark({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) => Icon(Icons.close_rounded, size: size, color: TifoColors.miss);
}

/// True while the app runs one of the dark palettes.
///
/// `Theme.of(context).brightness` is NOT a substitute here. The uikit resolves
/// `context.colors` from its own [ThemeController], which the ambient
/// [ThemeData] does not track — so the two can disagree, and did: the
/// tutorial's coach sheet painted its light body under text that
/// `foregroundDefault` had already turned white.
bool tifoIsDarkTheme(BuildContext context) => switch (context.themeController.currentTheme) {
  BaladyAppThemes.dark || BaladyAppThemes.darkDGA => true,
  _ => false,
};

/// Tokens the guided tutorial introduces on its own (Figma page "Tutorial",
/// row "Tutorial - Confirmed ENG" and its dark twin).
///
/// Anything the design shares with the uikit DGA palette is deliberately NOT
/// duplicated here — the overlay reads `context.colors` for it, so the tour
/// follows the app's light/dark switch for free:
///   * title / body text → `foregroundDefault` (#1B1B1B / #FFFFFF)
///   * muted tooltip link → `foregroundSoft` (#9DA4AE)
///   * `Next` button and the lit tooltip link → `accentDefault` (#1B8354)
///   * icon tile fill → `accentContainerDefault`
///   * dark sheet / tooltip body → `backgroundSurface2` (#0D121C)
///   * dark `‹` button → `neutralMuted` (#1F2A37)
abstract final class TifoTutorialTokens {
  /// Light coach sheet: the design's diagonal wash. Dark is flat
  /// `backgroundSurface2`, so it has no constant of its own.
  static const Color sheetWashStart = Color(0xFFFAFCFA);
  static const Color sheetWashEnd = Color(0xFFF5F0F8);

  /// Lit progress pill — a deeper green than `accent/default`.
  static const Color dotActive = Color(0xFF1A5E35);

  /// Dragger and the unlit dots, in both themes.
  static const Color hairline = Color(0x26000000); // #000 @15%

  /// Light-theme fill behind the ✕ and `‹` buttons. Dark swaps the `‹` for
  /// `neutralMuted`; the ✕ keeps this wash in both themes, per the design.
  static const Color buttonWash = Color(0x0F000000); // #000 @6%

  /// Wash behind each token icon tile.
  ///
  /// Not `accentContainerDefault`: the uikit token lands on the design in
  /// light (#25935F @10%) but drifts in dark, where DGA mixes it from
  /// `accentDefault` — #1B8354 @20% instead of the #25935F @20% the design
  /// asks for. Close, but a different hue, so the tile pins its own value.
  static const Color tileWash = Color(0x1A25935F);
  static const Color tileWashDark = Color(0x3325935F);

  /// Glyph strokes: ✕ in the sheet header, `‹` in the footer.
  static const Color closeStroke = Color(0xFF5A7566);
  static const Color backStroke = Color(0xFF3A5040);

  /// Sheet shadow — `0 -12 60 rgba(0,0,0,.25)`.
  static const BoxShadow sheetShadow = BoxShadow(
    color: Color(0x40000000),
    offset: Offset(0, -12),
    blurRadius: 60,
  );

  /// Tooltip shadows — `0 18 56 rgba(0,0,0,.07)` over `0 18 20 rgba(0,0,0,.05)`.
  static const List<BoxShadow> tooltipShadow = [
    BoxShadow(color: Color(0x12000000), offset: Offset(0, 18), blurRadius: 56),
    BoxShadow(color: Color(0x0D000000), offset: Offset(0, 18), blurRadius: 20),
  ];

  static const double sheetRadius = 24;
  static const double tooltipRadius = 16;

  /// Both the 36×36 ✕ and the 44×44 `‹` carry this radius.
  static const double buttonRadius = 14;

  /// Sheet header title — `Golos Text 600 18/20`. Heavier than [TifoText.h4],
  /// which the rest of TIFO uses at the same size.
  static const TextStyle title = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 20 / 18);

  /// Sheet body and the tile captions — `Golos Text 400 14/18`.
  static const TextStyle body = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 18 / 14);

  /// Tooltip `Previous` / `Next` links — `Golos Text 400 16/20`.
  static const TextStyle link = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 20 / 16);

  /// `Next` CTA label — `700 14/20`.
  static const TextStyle cta = TextStyle(fontSize: 14, fontWeight: FontWeight.w700, height: 20 / 14, color: Colors.white);
}

/// The tutorial's progress pills. Only the three coach-sheet steps are
/// counted — the tooltips between them carry no dot (Figma "Tutorial").
class TifoCoachDots extends StatelessWidget {
  const TifoCoachDots({required this.active, super.key});

  static const int total = 3;

  final int active;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (var i = 0; i < total; i++) ...[
        if (i > 0) const SizedBox(width: TifoSpacing.x2),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: i == active ? 24 : 7,
          height: 6,
          decoration: BoxDecoration(
            color: i == active ? TifoTutorialTokens.dotActive : TifoTutorialTokens.hairline,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    ],
  );
}
