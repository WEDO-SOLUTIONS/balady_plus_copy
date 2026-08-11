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

  /// Fallback fill for a neutral / unowned entity.
  static const Color neutralFill = Color(0xFF4C5E41);
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

/// Type ramp (`English/*` in Figma). Uses the "Golos" family bundled in the
/// `balady_uikit` package (weights 400–900); sizes/weights match the design.
abstract final class TifoText {
  /// The design font, shipped as fonts in `balady_uikit`.
  static const String family = 'Golos';
  static const String package = 'balady_uikit';

  static const TextStyle h2 = TextStyle(
    fontFamily: family,
    package: package,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: TifoColors.textDefault,
  );
  static const TextStyle h3 = TextStyle(
    fontFamily: family,
    package: package,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: TifoColors.textDefault,
  );
  static const TextStyle h4 = TextStyle(
    fontFamily: family,
    package: package,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.1,
    color: TifoColors.textDefault,
  );
  static const TextStyle bodyL = TextStyle(
    fontFamily: family,
    package: package,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.25,
    color: TifoColors.textDefault,
  );
  static const TextStyle bodyLSemi = TextStyle(
    fontFamily: family,
    package: package,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: TifoColors.textDefault,
  );
  static const TextStyle button = TextStyle(
    fontFamily: family,
    package: package,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: TifoColors.onAccent,
  );
  static const TextStyle captionRegular = TextStyle(
    fontFamily: family,
    package: package,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 14 / 11,
    color: TifoColors.textSoft,
  );
  static const TextStyle captionMedium = TextStyle(
    fontFamily: family,
    package: package,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 14 / 11,
    color: TifoColors.textSoft,
  );
  static const TextStyle overline = TextStyle(
    fontFamily: family,
    package: package,
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
    color: const Color(0xFFF3F4F6),
    borderRadius: BorderRadius.circular(TifoRadii.l),
    child: InkWell(
      borderRadius: BorderRadius.circular(TifoRadii.l),
      onTap: onPressed,
      child: SizedBox(
        height: 48,
        child: Center(
          child: Text(label, style: TifoText.bodyLSemi.copyWith(color: TifoColors.textStrong)),
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
String tifoLocalizedDigits(BuildContext context, int n) {
  if (Localizations.localeOf(context).languageCode != 'ar') {
    return '$n';
  }
  const easternArabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  return n.toString().split('').map((d) => easternArabicDigits[int.parse(d)]).join();
}

/// "Since N day(s) ago" — Arabic day counts need the full 0/1/2/few/many/other
/// plural set (see [ArPlurals]/[getPluralForAr]), not just singular/plural.
/// Zero/one/two bake the count into the translation itself; few/many/other
/// prepend the (locale-formatted) number, matching the existing
/// `ArPlurals.stations`/`.transfers` helpers.
String tifoStandingDaysAgo(BuildContext context, int days) {
  final l10n = AppLocalizations.of(context);
  final digits = tifoLocalizedDigits(context, days);
  return switch (getPluralForAr(days)) {
    Plurals.zero => l10n.tifoStandingDaysZero,
    Plurals.one => l10n.tifoStandingDaysOne,
    Plurals.two => l10n.tifoStandingDaysTwo,
    Plurals.few => '$digits ${l10n.tifoStandingDaysFew}',
    Plurals.many => '$digits ${l10n.tifoStandingDaysMany}',
    Plurals.others => '$digits ${l10n.tifoStandingDaysOther}',
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
                    ).stepOfTotal(tifoLocalizedDigits(context, step), tifoLocalizedDigits(context, total)),
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
    color: context.colors.foregroundMuted,
    shape: CircleBorder(side: BorderSide(color: context.colors.foregroundMuted)),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(width: 36, height: 36, child: Icon(icon, size: 16, color: context.colors.foregroundDefault)),
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
